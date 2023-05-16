const {
    BjjProvider,
    CredentialStorage,
    CredentialWallet,
    defaultEthConnectionConfig,
    EthStateStorage,
    ICredentialWallet,
    IDataStorage,
    Identity,
    IdentityCreationOptions,
    IdentityStorage,
    IdentityWallet,
    IIdentityWallet,
    InMemoryDataSource,
    InMemoryMerkleTreeStorage,
    InMemoryPrivateKeyStore,
    KMS,
    KmsKeyType,
    byteEncoder,
    DidMethod,
    Profile,
    W3CCredential,
    CredentialRequest,
    EthConnectionConfig,
    CircuitStorage,
    CircuitData,
    FSKeyLoader,
    CircuitId,
    IStateStorage,
    ProofService,
    ZeroKnowledgeProofRequest,
    PackageManager,
    AuthorizationRequestMessage,
    PROTOCOL_CONSTANTS,
    AuthHandler,
    AuthDataPrepareFunc,
    StateVerificationFunc,
    DataPrepareHandlerFunc,
    VerificationHandlerFunc,
    IPackageManager,
    VerificationParams,
    ProvingParams,
    ZKPPacker,
    PlainPacker,
    ICircuitStorage,
    core,
    ZKPRequestWithCredential,
    CredentialStatusType,
  }  = require("@0xpolygonid/js-sdk");
const rhsUrl = 'http://rhs.com/node';
const path = require("path");

async function identityCreation(){
    
    console.log("=============== key creation ===============")

    const dataStorage = initDataStorage();
    const credentialWallet = await initCredentialWallet(dataStorage);
    const identityWallet = await initIdentityWallet(dataStorage,credentialWallet);
  
    const { did, credential } = await identityWallet.createIdentity({
        method: core.DidMethod.PolygonId,
        blockchain: core.Blockchain.Polygon,
        networkId: core.NetworkId.Mumbai,
        //seed: seedPhraseIssuer,
        revocationOpts: {
            type: CredentialStatusType.Iden3ReverseSparseMerkleTreeProof,
            baseUrl: rhsUrl
        }
    }
);
  
    console.log("=============== did ===============")
    console.log(did.toString());
    console.log("=============== Auth BJJ credential ===============")
    console.log(JSON.stringify(credential));
}

function initDataStorage() {

    // let conf= defaultEthConnectionConfig;
    // conf.contractAddress = "< contract address >"
    // conf.url  = "< rpc url > "
 
    var dataStorage = {
        credential: new CredentialStorage(new InMemoryDataSource()),
        identity: new IdentityStorage(new InMemoryDataSource(),new InMemoryDataSource()),
        mt: new InMemoryMerkleTreeStorage(40),
        states: new EthStateStorage(defaultEthConnectionConfig),
    };
        return dataStorage;
}

async function initCredentialWallet(dataStorage) {
    return new CredentialWallet(dataStorage);
}

async function initIdentityWallet(dataStorage,credentialWallet) {
    const memoryKeyStore = new InMemoryPrivateKeyStore();
    const bjjProvider = new BjjProvider(KmsKeyType.BabyJubJub, memoryKeyStore);
    const kms = new KMS();
    kms.registerKeyProvider(KmsKeyType.BabyJubJub, bjjProvider);

    return new IdentityWallet(kms, dataStorage, credentialWallet);
}

async function issueCredential() {
    console.log("=============== issue credential ===============");
  
    const dataStorage = initDataStorage();
    const credentialWallet = await initCredentialWallet(dataStorage);
    const identityWallet = await initIdentityWallet(
      dataStorage,
      credentialWallet
    );
  
    const { did: userDID, credential: authBJJCredentialUser } =
      await identityWallet.createIdentity({
        method: core.DidMethod.PolygonId,
        blockchain: core.Blockchain.Polygon,
        networkId: core.NetworkId.Mumbai,
        revocationOpts: {
          type: CredentialStatusType.SparseMerkleTreeProof,
          baseUrl: rhsUrl,
        },
      });
  
    console.log("=============== user did ===============");
    console.log(userDID.toString());
  
    const { did: issuerDID, credential: issuerAuthBJJCredential } =
      await identityWallet.createIdentity({
        method: core.DidMethod.PolygonId,
        blockchain: core.Blockchain.Polygon,
        networkId: core.NetworkId.Mumbai,
        revocationOpts: {
          type: CredentialStatusType.SparseMerkleTreeProof,
          baseUrl: rhsUrl,
        }, // url to check revocation status of auth bjj credential
      });

    
    const credentialRequest = {
      credentialSchema:
        "https://raw.githubusercontent.com/iden3/claim-schema-vocab/main/schemas/json/KYCAgeCredential-v3.json",
      type: "KYCAgeCredential",
      credentialSubject: {
        id: userDID.toString(),
        birthday: 19960424,
        documentType: 99,
      },
      expiration: 12545678888,
      revocationOpts: {
        type: CredentialStatusType.SparseMerkleTreeProof,
        baseUrl: rhsUrl,
      },
    };

    const credential = await identityWallet.issueCredential(
      issuerDID,
      credentialRequest
    );
  
    console.log("===============  credential ===============");
    console.log(JSON.stringify(credential));
  
    await dataStorage.credential.saveCredential(credential);
}

async function handleAuthRequest() {
  console.log("=============== handle auth request ===============");

  const dataStorage = initDataStorage();
  const credentialWallet = await initCredentialWallet(dataStorage);
  const identityWallet = await initIdentityWallet(
    dataStorage,
    credentialWallet
  );
  const circuitStorage = await initCircuitStorage();
  const proofService = await initProofService(
    identityWallet,
    credentialWallet,
    dataStorage.states,
    circuitStorage
  );

  const { did: userDID, credential: authBJJCredentialUser } =
    await identityWallet.createIdentity({
      method: core.DidMethod.PolygonId,
      blockchain: core.Blockchain.Polygon,
      networkId: core.NetworkId.Mumbai,
      revocationOpts: {
        type: CredentialStatusType.SparseMerkleTreeProof,
        baseUrl: rhsUrl,
      },
    });

  console.log("=============== user did ===============");
  console.log(userDID.toString());

  const { did: issuerDID, credential: issuerAuthBJJCredential } =
    await identityWallet.createIdentity({
      method: core.DidMethod.PolygonId,
      blockchain: core.Blockchain.Polygon,
      networkId: core.NetworkId.Mumbai,
      revocationOpts: {
        type: CredentialStatusType.SparseMerkleTreeProof,
        baseUrl: rhsUrl,
      },
    });

  const credentialRequest = {
    credentialSchema:
      "https://raw.githubusercontent.com/iden3/claim-schema-vocab/main/schemas/json/KYCAgeCredential-v3.json",
    type: "KYCAgeCredential",
    credentialSubject: {
      id: userDID.toString(),
      birthday: 19960424,
      documentType: 99,
    },
    expiration: 12345678888,
    revocationOpts: {
      type: CredentialStatusType.SparseMerkleTreeProof,
      baseUrl: rhsUrl,
    },
  };
  const credential = await identityWallet.issueCredential(
    issuerDID,
    credentialRequest
  );

  await dataStorage.credential.saveCredential(credential);

  console.log(
    "================= generate SparseMerkleTreeProof ======================="
  );

  const res = await identityWallet.addCredentialsToMerkleTree(
    [credential],
    issuerDID
  );

  console.log("================= push states to rhs ===================");

  await identityWallet.publishStateToRHS(issuerDID, rhsUrl);

  console.log("================= publish to blockchain ===================");

  const ethSigner = new ethers.Wallet(
    walletKey,
    (dataStorage.states).provider
  );
  const txId = await proofService.transitState(
    issuerDID,
    res.oldTreeState,
    true,
    dataStorage.states,
    ethSigner
  );
  console.log(txId);

  console.log(
    "================= generate credentialAtomicSigV2 ==================="
  );

  const proofReqSig = {
    id: 1,
    circuitId: CircuitId.AtomicQuerySigV2,
    optional: false,
    query: {
      allowedIssuers: ["*"],
      type: credentialRequest.type,
      context:
        "https://raw.githubusercontent.com/iden3/claim-schema-vocab/main/schemas/json-ld/kyc-v3.json-ld",
      credentialSubject: {
        documentType: {
          $eq: 99,
        },
      },
    },
  };

  console.log("=================  credential auth request ===================");

  var authRequest = {
    id: "fe6354fe-3db2-48c2-a779-e39c2dda8d90",
    thid: "fe6354fe-3db2-48c2-a779-e39c2dda8d90",
    typ: PROTOCOL_CONSTANTS.MediaType.PlainMessage,
    from: issuerDID.toString(),
    type: PROTOCOL_CONSTANTS.PROTOCOL_MESSAGE_TYPE
      .AUTHORIZATION_REQUEST_MESSAGE_TYPE,
    body: {
      callbackUrl: "http://testcallback.com",
      message: "message to sign",
      scope: [proofReqSig],
      reason: "verify age",
    },
  };
  console.log(JSON.stringify(authRequest));

  const credsWithIden3MTPProof =
    await identityWallet.generateIden3SparseMerkleTreeProof(
      issuerDID,
      res.credentials,
      txId
    );

  console.log(credsWithIden3MTPProof);
  credentialWallet.saveAll(credsWithIden3MTPProof);

  var authRawRequest = new TextEncoder().encode(JSON.stringify(authRequest));

  // * on the user side */

  console.log("============== handle auth request ==============");
  const authV2Data = await circuitStorage.loadCircuitData(CircuitId.AuthV2);
  let pm = await initPackageManager(
    authV2Data,
    proofService.generateAuthV2Inputs.bind(proofService),
    proofService.verifyState.bind(proofService)
  );

  const authHandler = new AuthHandler(pm, proofService, credentialWallet);
  const authHandlerRequest =
    await authHandler.handleAuthorizationRequestForGenesisDID(
      userDID,
      authRawRequest
    );
  console.log(JSON.stringify(authHandlerRequest, null, 2));
}

async function initProofService(identityWallet,credentialWallet,stateStorage,circuitStorage){
  return new ProofService(
    identityWallet,
    credentialWallet,
    circuitStorage,
    stateStorage
  );
}

async function initCircuitStorage(){
  const circuitStorage = new CircuitStorage(
    new InMemoryDataSource()
  );

  const loader = new FSKeyLoader(path.join(__dirname, './server/web3/'));

  await circuitStorage.saveCircuitData(CircuitId.AuthV2, {
    circuitId: CircuitId.AuthV2,
    wasm: await loader.load(`${CircuitId.AuthV2.toString()}/circuit.wasm`),
    provingKey: await loader.load(
      `${CircuitId.AuthV2.toString()}/circuit_final.zkey`
    ),
    verificationKey: await loader.load(
      `${CircuitId.AuthV2.toString()}/verification_key.json`
    ),
  });

  await circuitStorage.saveCircuitData(CircuitId.AtomicQuerySigV2, {
    circuitId: CircuitId.AtomicQuerySigV2,
    wasm: await loader.load(
      `${CircuitId.AtomicQuerySigV2.toString()}/circuit.wasm`
    ),
    provingKey: await loader.load(
      `${CircuitId.AtomicQuerySigV2.toString()}/circuit_final.zkey`
    ),
    verificationKey: await loader.load(
      `${CircuitId.AtomicQuerySigV2.toString()}/verification_key.json`
    ),
  });

  await circuitStorage.saveCircuitData(CircuitId.StateTransition, {
    circuitId: CircuitId.StateTransition,
    wasm: await loader.load(
      `${CircuitId.StateTransition.toString()}/circuit.wasm`
    ),
    provingKey: await loader.load(
      `${CircuitId.StateTransition.toString()}/circuit_final.zkey`
    ),
    verificationKey: await loader.load(
      `${CircuitId.StateTransition.toString()}/verification_key.json`
    ),
  });

  await circuitStorage.saveCircuitData(CircuitId.AtomicQueryMTPV2, {
    circuitId: CircuitId.AtomicQueryMTPV2,
    wasm: await loader.load(
      `${CircuitId.AtomicQueryMTPV2.toString()}/circuit.wasm`
    ),
    provingKey: await loader.load(
      `${CircuitId.AtomicQueryMTPV2.toString()}/circuit_final.zkey`
    ),
    verificationKey: await loader.load(
      `${CircuitId.AtomicQueryMTPV2.toString()}/verification_key.json`
    ),
  });
  return circuitStorage;
}

handleAuthRequest();
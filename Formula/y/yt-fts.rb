class YtFts < Formula
  include Language::Python::Virtualenv

  desc "Search all of a YouTube channel from the command line"
  homepage "https://github.com/NotJoeMartinez/yt-fts"
  url "https://files.pythonhosted.org/packages/9b/35/eb19cdc9b957c3366422bb89a3e33dc6bc102fdb93987c7fbd4fd7823df5/yt_fts-0.1.47.tar.gz"
  sha256 "101290acfb62ada68f762ed30c1b65f7ff1fdafa0d545bde992389ac4a72d825"
  version "0.1.47"
  license "Unlicense"

  depends_on "rust" => :build #for bcrypt
  depends_on "cmake" => :build # for hnswlib
  depends_on "python3"
  depends_on "yt-dlp"
  depends_on "onnxruntime"
  depends_on "numpy" 
  depends_on "certifi" 

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/67/fe/8c7b275824c6d2cd17c93ee85d0ee81c090285b6d52f4876ccc47cf9c3c4/annotated_types-0.6.0.tar.gz"
    sha256 "563339e807e53ffd9c267e99fc6d9ea23eb8443c08f112651963e24e22f84a5d"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/db/4d/3970183622f0330d3c23d9b8a5f52e365e50381fd484d08e3285104333d3/anyio-4.3.0.tar.gz"
    sha256 "f75253795a87df48568485fd18cdd2a3fa5c4f7c5be8e5e36637733fce06fed6"
  end

  resource "asgiref" do
    url "https://files.pythonhosted.org/packages/29/38/b3395cc9ad1b56d2ddac9970bc8f4141312dbaec28bc7c218b0dfafd0f42/asgiref-3.8.1.tar.gz"
    sha256 "c343bd80a0bec947a9860adb4c432ffa7db769836c64238fc34bdc3fec84d590"
  end

  resource "backoff" do
    url "https://files.pythonhosted.org/packages/47/d7/5bbeb12c44d7c4f2fb5b56abce497eb5ed9f34d85701de869acedd602619/backoff-2.2.1.tar.gz"
    sha256 "03f829f5bb1923180821643f8753b0502c3b682293992485b0eef2807afa5cba"
  end

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/ca/e9/0b36987abbcd8c9210c7b86673d88ff0a481b4610630710fb80ba5661356/bcrypt-4.1.3.tar.gz"
    sha256 "2ee15dd749f5952fe3f0430d0ff6b74082e159c50332a1413d51b5689cf06623"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/b3/ca/824b1195773ce6166d388573fc106ce56d4a805bd7427b624e063596ec58/beautifulsoup4-4.12.3.tar.gz"
    sha256 "74e3d1928edc070d21748185c46e3fb33490f22f52a3addee9aee0f4f7781051"
  end

  resource "build" do
    url "https://files.pythonhosted.org/packages/ce/9e/2d725d2f7729c6e79ca62aeb926492abbc06e25910dd30139d60a68bcb19/build-1.2.1.tar.gz"
    sha256 "526263f4870c26f26c433545579475377b2b7588b6f1eac76a001e873ae3e19d"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/b3/4d/27a3e6dd09011649ad5210bdf963765bc8fa81a0827a4fc01bafd2705c5b/cachetools-5.3.3.tar.gz"
    sha256 "ba29e2dfa0b8b556606f097407ed1aa62080ee108ab0dc5ec9d6a723a007d105"
  end


  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "chroma-hnswlib" do
    url "https://files.pythonhosted.org/packages/c0/59/1224cbae62c7b84c84088cdf6c106b9b2b893783c000d22c442a1672bc75/chroma-hnswlib-0.7.3.tar.gz"
    sha256 "b6137bedde49fffda6af93b0297fe00429fc61e5a072b1ed9377f909ed95a932"
  end

  resource "chromadb" do
    url "https://files.pythonhosted.org/packages/47/6b/a5465827d8017b658d18ad1e63d2dc31109dec717c6bd068e82485186f4b/chromadb-0.4.24.tar.gz"
    sha256 "a5c80b4e4ad9b236ed2d4899a5b9e8002b489293f2881cb2cadab5b199ee1c72"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "click-default-group" do
    url "https://files.pythonhosted.org/packages/1d/ce/edb087fb53de63dad3b36408ca30368f438738098e668b78c87f93cd41df/click_default_group-1.2.4.tar.gz"
    sha256 "eb3f3c99ec0d456ca6cd2a7f08f7d4e91771bef51b01bdd9580cc6450fe1251e"
  end

  resource "coloredlogs" do
    url "https://files.pythonhosted.org/packages/cc/c7/eed8f27100517e8c0e6b923d5f0845d0cb99763da6fdee00478f91db7325/coloredlogs-15.0.1.tar.gz"
    sha256 "7c991aa71a4577af2f82600d8f8f3a89f936baeaf9b50a9c197da014e5bf16b0"
  end

  resource "Deprecated" do
    url "https://files.pythonhosted.org/packages/92/14/1e41f504a246fc224d2ac264c227975427a85caf37c3979979edb9b1b232/Deprecated-1.2.14.tar.gz"
    sha256 "e5323eb936458dccc2582dc6f9c322c852a775a27065ff2b0c4970b9d53d01b3"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/fc/f8/98eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3/distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/37/7d/c871f55054e403fdfd6b8f65fd6d1c4e147ed100d3e9f9ba1fe695403939/dnspython-2.6.1.tar.gz"
    sha256 "e8f0f9c23a7b7cb99ded64e6c3a6f3e701d78f50c55e002b839dea7225cff7cc"
  end

  resource "email-validator" do
    url "https://files.pythonhosted.org/packages/63/82/2914bff80ebee8c027802a664ad4b4caad502cd594e358f76aff395b5e56/email_validator-2.1.1.tar.gz"
    sha256 "200a70680ba08904be6d1eef729205cc0d687634399a5924d842533efb824b84"
  end

  resource "fastapi" do
    url "https://files.pythonhosted.org/packages/0e/1f/f4a99e92c583780787e04b05aa9d8a8db9ec76d091d81545948a006f5b44/fastapi-0.111.0.tar.gz"
    sha256 "b9db9dd147c91cb8b769f7183535773d8741dd46f9dc6676cd82eab510228cd7"
  end

  resource "fastapi-cli" do
    url "https://files.pythonhosted.org/packages/39/1a/132f46e6a7122970a102fca6f71baa3b574be1ecac0f6888c68e6625fa33/fastapi_cli-0.0.2.tar.gz"
    sha256 "589565ba758432632eadcf7b950e0ec76bb283b549784d9df17f261a8a9de476"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/06/ae/f8e03746f0b62018dcf1120f5ad0a1db99e55991f2cda0cf46edc8b897ea/filelock-3.14.0.tar.gz"
    sha256 "6ea72da3be9b8c82afd3edcf99f2fffbb5076335a5ae4d03248bb5b6c3eae78a"
  end

  resource "flatbuffers" do
    url "https://files.pythonhosted.org/packages/a9/74/2df95ef84b214d2bee0886d572775a6f38793f5ca6d7630c3239c91104ac/flatbuffers-24.3.25.tar.gz"
    sha256 "de2ec5b203f21441716617f38443e0a8ebf3d25bf0d9c0bb0ce68fa00ad546a4"
  end

  resource "fsspec" do
    url "https://files.pythonhosted.org/packages/8b/b8/e3ba21f03c00c27adc9a8cd1cab8adfb37b6024757133924a9a4eab63a83/fsspec-2024.3.1.tar.gz"
    sha256 "f39780e282d7d117ffb42bb96992f8a90795e4d0fb0f661a70ca39fe9c43ded9"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/18/b2/f14129111cfd61793609643a07ecb03651a71dd65c6974f63b0310ff4b45/google-auth-2.29.0.tar.gz"
    sha256 "672dff332d073227550ffc7457868ac4218d6c500b155fe6cc17d2b13602c360"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/d2/dc/291cebf3c73e108ef8210f19cb83d671691354f4f7dd956445560d778715/googleapis-common-protos-1.63.0.tar.gz"
    sha256 "17ad01b11d5f1d0171c06d3ba5c04c54474e883b66b949722b4938ee2694ef4e"
  end

  resource "grpcio" do
    url "https://files.pythonhosted.org/packages/0c/2a/23943e19b4bbbdad60a9d881e44cd53bb48b31c7419ebb7b983edfbbb708/grpcio-1.63.0.tar.gz"
    sha256 "f3023e14805c61bc439fb40ca545ac3d5740ce66120a678a3c6c2c55b70343d1"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/f5/38/3af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03/h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/17/b0/5e8b8674f8d203335a62fdfcfa0d11ebe09e23613c3391033cbba35f7926/httpcore-1.0.5.tar.gz"
    sha256 "34a38e2f9291467ee3b44e89dd52615370e152954ba21721378a87b2960f7a61"
  end

  resource "httptools" do
    url "https://files.pythonhosted.org/packages/67/1d/d77686502fced061b3ead1c35a2d70f6b281b5f723c4eff7a2277c04e4a2/httptools-0.6.1.tar.gz"
    sha256 "c6e26c30455600b95d94b1b836085138e82f177351454ee841c148f93a9bad5a"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/5c/2d/3da5bdf4408b8b2800061c339f240c1802f2e82d55e50bd39c5a881f47f0/httpx-0.27.0.tar.gz"
    sha256 "a0cb88a46f32dc874e04ee956e4c2764aba2aa228f650b06788ba6bda2962ab5"
  end

  resource "huggingface-hub" do
    url "https://files.pythonhosted.org/packages/63/9b/7ba10dafb38e4e4ea19f616087722db564f1fe8551b3825cb507351ba085/huggingface_hub-0.23.0.tar.gz"
    sha256 "7126dedd10a4c6fac796ced4d87a8cf004efc722a5125c2c09299017fa366fa9"
  end

  resource "humanfriendly" do
    url "https://files.pythonhosted.org/packages/cc/3f/2c29224acb2e2df4d2046e4c73ee2662023c58ff5b113c4c1adac0886c43/humanfriendly-10.0.tar.gz"
    sha256 "6b0b831ce8f15f7300721aa49829fc4e83921a9a301cc7f606be6686a2288ddc"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/db/5a/392426ddb5edfebfcb232ab7a47e4a827aa1d5b5267a5c20c448615feaa9/importlib_metadata-7.0.0.tar.gz"
    sha256 "7fc841f8b8332803464e5dc1c63a2e59121f46ca186c0e2e182e80bf8c1319f7"
  end

  resource "importlib-resources" do
    url "https://files.pythonhosted.org/packages/c8/9d/6ee73859d6be81c6ea7ebac89655e92740296419bd37e5c8abdb5b62fd55/importlib_resources-6.4.0.tar.gz"
    sha256 "cdb2b453b8046ca4e3798eb1d84f3cce1446a0e8e7b5ef4efb600f19fc398145"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/b2/5e/3a21abf3cd467d7876045335e681d276ac32492febe6d98ad89562d1a7e1/Jinja2-3.1.3.tar.gz"
    sha256 "ac8bd6544d4bb2c9792bf3a159e80bba8fda7f07e81bc3aed565432d5925ba90"
  end

  resource "kubernetes" do
    url "https://files.pythonhosted.org/packages/de/07/d01320a808abaab3426db63476adcb31f7e23fe8c08aef175d7883ea978a/kubernetes-29.0.0.tar.gz"
    sha256 "c4812e227ae74d07d53c88293e564e54b850452715a59a927e7e1bc6b9a60459"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/87/5b/aae44c6655f3801e81aa3eef09dbbf012431987ba564d7231722f68df02d/MarkupSafe-2.1.5.tar.gz"
    sha256 "d283d37a890ba4c1ae73ffadf8046435c76e7bc2247bbb63c00bd1a709c6544b"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "mmh3" do
    url "https://files.pythonhosted.org/packages/63/96/aa247e82878b123468f0079ce2ac77e948315bab91ce45d2934a62e0af95/mmh3-4.1.0.tar.gz"
    sha256 "a1cf25348b9acd229dda464a094d6170f47d2850a1fcb762a3b6172d2ce6ca4a"
  end

  resource "monotonic" do
    url "https://files.pythonhosted.org/packages/ea/ca/8e91948b782ddfbd194f323e7e7d9ba12e5877addf04fb2bf8fca38e86ac/monotonic-1.6.tar.gz"
    sha256 "3a55207bcfed53ddd5c5bae174524062935efed17792e9de2ad0205ce9ad63f7"
  end

  resource "mpmath" do
    url "https://files.pythonhosted.org/packages/e0/47/dd32fa426cc72114383ac549964eecb20ecfd886d1e5ccf5340b55b02f57/mpmath-1.3.0.tar.gz"
    sha256 "7a28eb2a9774d00c7bc92411c19a89209d5da7c4c9a9e227be8330a23a25b91f"
  end


  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/6d/fa/fbf4001037904031639e6bfbfc02badfc7e12f137a8afa254df6c4c8a670/oauthlib-3.2.2.tar.gz"
    sha256 "9859c40929662bec5d64f34d01c99e093149682a3f38915dc0655d5a633dd918"
  end

  resource "openai" do
    url "https://files.pythonhosted.org/packages/f6/77/5853830ae66f7f195094bbe8de95d3e6a204801c5ee3538e97f9ef60de6c/openai-1.16.2.tar.gz"
    sha256 "c93d5efe5b73b6cb72c4cd31823852d2e7c84a138c0af3cbe4a8eb32b1164ab2"
  end

  resource "opentelemetry-api" do
    url "https://files.pythonhosted.org/packages/3a/9e/77153a81a6eba4efcc28d8a4a00ae1b619108bf0225a879fb7084cb402db/opentelemetry_api-1.24.0.tar.gz"
    sha256 "42719f10ce7b5a9a73b10a4baf620574fb8ad495a9cbe5c18d76b75d8689c67e"
  end

  resource "opentelemetry-exporter-otlp-proto-common" do
    url "https://files.pythonhosted.org/packages/1f/8e/cd1087d2cf8efc5dfca813c87856ac7ecaeb14078c2bdffc51d6e2a734d9/opentelemetry_exporter_otlp_proto_common-1.24.0.tar.gz"
    sha256 "5d31fa1ff976cacc38be1ec4e3279a3f88435c75b38b1f7a099a1faffc302461"
  end

  resource "opentelemetry-exporter-otlp-proto-grpc" do
    url "https://files.pythonhosted.org/packages/2c/8a/ec5de727903f4e93ad33e2f1472cc9df68d5bb87c2cbb0132ac30777854a/opentelemetry_exporter_otlp_proto_grpc-1.24.0.tar.gz"
    sha256 "217c6e30634f2c9797999ea9da29f7300479a94a610139b9df17433f915e7baa"
  end

  resource "opentelemetry-instrumentation" do
    url "https://files.pythonhosted.org/packages/b2/bd/dcf2c4c1132c580b60b548b17c4d115f1a2224961eac0a0138bf5f84d751/opentelemetry_instrumentation-0.45b0.tar.gz"
    sha256 "6c47120a7970bbeb458e6a73686ee9ba84b106329a79e4a4a66761f933709c7e"
  end

  resource "opentelemetry-instrumentation-asgi" do
    url "https://files.pythonhosted.org/packages/26/a5/dd1ed5e97ee8665413b329a890872422d07c83e15358c07356722bf85a7c/opentelemetry_instrumentation_asgi-0.45b0.tar.gz"
    sha256 "97f55620f163fd3d20323e9fd8dc3aacc826c03397213ff36b877e0f4b6b08a6"
  end

  resource "opentelemetry-instrumentation-fastapi" do
    url "https://files.pythonhosted.org/packages/b7/22/8796f545772847ee22b982a508cef3fe66ae71c6c1c8fa7aad475f388b18/opentelemetry_instrumentation_fastapi-0.45b0.tar.gz"
    sha256 "5a6b91e1c08a01601845fcfcfdefd0a2aecdb3c356d4a436a3210cb58c21487e"
  end

  resource "opentelemetry-proto" do
    url "https://files.pythonhosted.org/packages/69/7a/6630ab9b937603137fa91b74053fb78cdc446db9f83ce1c86d6a71c48768/opentelemetry_proto-1.24.0.tar.gz"
    sha256 "ff551b8ad63c6cabb1845ce217a6709358dfaba0f75ea1fa21a61ceddc78cab8"
  end

  resource "opentelemetry-sdk" do
    url "https://files.pythonhosted.org/packages/a2/e3/38a0ee0aa9dc5886e3235f4c83bf374a351109332191394147f79a484c31/opentelemetry_sdk-1.24.0.tar.gz"
    sha256 "75bc0563affffa827700e0f4f4a68e1e257db0df13372344aebc6f8a64cde2e5"
  end

  resource "opentelemetry-semantic-conventions" do
    url "https://files.pythonhosted.org/packages/8d/f8/c8de6e148aedf56adf16981ed590d05e7bbe5594f6dfdd4eb780c5da0358/opentelemetry_semantic_conventions-0.45b0.tar.gz"
    sha256 "7c84215a44ac846bc4b8e32d5e78935c5c43482e491812a0bb8aaf87e4d92118"
  end

  resource "opentelemetry-util-http" do
    url "https://files.pythonhosted.org/packages/03/99/6784a4f7fea0d2ef818a9ccbd8ea43abc163ab6f95a13b1e27edce66dafe/opentelemetry_util_http-0.45b0.tar.gz"
    sha256 "4ce08b6a7d52dd7c96b7705b5b4f06fdb6aa3eac1233b3b0bfef8a0cab9a92cd"
  end

  resource "orjson" do
    url "https://files.pythonhosted.org/packages/f8/16/c10c42b69beeebe8bd136ee28b76762837479462787be57f11e0ab5d6f5d/orjson-3.10.3.tar.gz"
    sha256 "2b166507acae7ba2f7c315dcf185a9111ad5e992ac81f2d507aac39193c2c818"
  end

  resource "overrides" do
    url "https://files.pythonhosted.org/packages/36/86/b585f53236dec60aba864e050778b25045f857e17f6e5ea0ae95fe80edd2/overrides-7.7.0.tar.gz"
    sha256 "55158fa3d93b98cc75299b1e67078ad9003ca27945c76162c1c0766d6f91820a"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/ee/b5/b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4d/packaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/96/2d/02d4312c973c6050a18b314a5ad0b3210edb65a906f868e31c111dede4a6/pluggy-1.5.0.tar.gz"
    sha256 "2cffa88e94fdc978c4c574f15f9e59b7f4201d439195c3715ca9e2486f1d0cf1"
  end

  resource "posthog" do
    url "https://files.pythonhosted.org/packages/d8/c8/8a7308d5355fedfc400098a75fd191cf615b55aa22ef2a937995326e6f5e/posthog-3.5.0.tar.gz"
    sha256 "8f7e3b2c6e8714d0c0c542a2109b83a7549f63b7113a133ab2763a89245ef2ef"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/5e/d8/65adb47d921ce828ba319d6587aa8758da022de509c3862a70177a958844/protobuf-4.25.3.tar.gz"
    sha256 "25b5d0b42fd000320bd7830b349e3b696435f3b329810427a6bcce6a5492cc5c"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/4a/a3/d2157f333900747f20984553aca98008b6dc843eb62f3a36030140ccec0d/pyasn1-0.6.0.tar.gz"
    sha256 "3a35ab2c4b5ef98e17dfdec8ab074046fbda76e281c5a706ccd82328cfc8f64c"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/f7/00/e7bd1dec10667e3f2be602686537969a7ac92b0a7c5165be2e5875dc3971/pyasn1_modules-0.4.0.tar.gz"
    sha256 "831dbcea1b177b28c9baddf4c6d1013c24c3accd14a1873fffaa6a2e905f17b6"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/1f/74/0d009e056c2bd309cdc053b932d819fcb5ad3301fc3e690c097e1de3e714/pydantic-2.7.1.tar.gz"
    sha256 "e9dbb5eada8abe4d9ae5f46b9939aead650cd2b68f249bb3a8139dbe125803cc"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/e9/23/a609c50e53959eb96393e42ae4891901f699aaad682998371348650a6651/pydantic_core-2.18.2.tar.gz"
    sha256 "2e29d20810dfc3043ee13ac7d9e25105799817683348823f305ab3f349b9386e"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/8e/62/8336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31/pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "PyPika" do
    url "https://files.pythonhosted.org/packages/c7/2c/94ed7b91db81d61d7096ac8f2d325ec562fc75e35f3baea8749c85b28784/PyPika-0.48.9.tar.gz"
    sha256 "838836a61747e7c8380cd1b7ff638694b7a7335345d0f559b04b2cd832ad5378"
  end

  resource "pyproject-hooks" do
    url "https://files.pythonhosted.org/packages/c7/07/6f63dda440d4abb191b91dc383b472dae3dd9f37e4c1e4a5c3db150531c6/pyproject_hooks-1.1.0.tar.gz"
    sha256 "4b37730834edbd6bd37f26ece6b44802fb1c1ee2ece0e54ddff8bfc06db86965"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/bc/57/e84d88dfe0aec03b7a2d4327012c1627ab5f03652216c63d49846d7a6c58/python-dotenv-1.0.1.tar.gz"
    sha256 "e324ee90a023d808f1959c46bcbc04446a10ced277783dc6ee09987c37ec10ca"
  end

  resource "python-multipart" do
    url "https://files.pythonhosted.org/packages/5c/0f/9c55ac6c84c0336e22a26fa84ca6c51d58d7ac3a2d78b0dfa8748826c883/python_multipart-0.0.9.tar.gz"
    sha256 "03f54688c663f1b7977105f021043b0793151e4cb1c1a9d4a11fc13d622c4026"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/42/f2/05f29bc3913aea15eb670be136045bf5c5bbf4b99ecb839da9b422bb2c85/requests-oauthlib-2.0.0.tar.gz"
    sha256 "b3dffaebd884d8cd778494369603a9e7b58d29111bf6b41bdc2dcd87203af4e9"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/b3/01/c954e134dc440ab5f96952fe52b4fdc64225530320a910473c1fe270d9aa/rich-13.7.1.tar.gz"
    sha256 "9be308cb1fe2f1f57d67ce99e95af38a1e2bc71ad9813b0e247cf7ffbcc3a432"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/aa/65/7d973b89c4d2351d7fb232c2e452547ddfa243e93131e7cfa766da627b52/rsa-4.9.tar.gz"
    sha256 "e38464a49c6c85d7f1351b0126661487a7e0a14a50f1675ec50eb34d4f20ef21"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/ce/21/952a240de1c196c7e3fbcd4e559681f0419b1280c617db21157a0390717b/soupsieve-2.5.tar.gz"
    sha256 "5663d5a7b3bfaeee0bc4372e7fc48f9cff4940b3eec54a6451cc5299f1097690"
  end

  resource "sqlite-fts4" do
    url "https://files.pythonhosted.org/packages/c2/6d/9dad6c3b433ab8912ace969c66abd595f8e0a2ccccdb73602b1291dbda29/sqlite-fts4-1.0.3.tar.gz"
    sha256 "78b05eeaf6680e9dbed8986bde011e9c086a06cb0c931b3cf7da94c214e8930c"
  end

  resource "sqlite-utils" do
    url "https://files.pythonhosted.org/packages/ae/70/dc7c74592f30ac20be23eaeeb2a84ee6e2c12c21beb07a3eb53ead77de1f/sqlite-utils-3.36.tar.gz"
    sha256 "dcc311394fe86dc16f65037b0075e238efcfd2e12e65d53ed196954502996f3c"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/61/b5/6bceb93ff20bd7ca36e6f7c540581abb18f53130fabb30ba526e26fd819b/starlette-0.37.2.tar.gz"
    sha256 "9af890290133b79fc3db55474ade20f6220a364a0402e0b556e7cd5e1e093823"
  end

  resource "sympy" do
    url "https://files.pythonhosted.org/packages/e5/57/3485a1a3dff51bfd691962768b14310dae452431754bfc091250be50dd29/sympy-1.12.tar.gz"
    sha256 "ebf595c8dac3e0fdc4152c51878b498396ec7f30e7a914d6071e674d49420fb8"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/ec/fe/802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1/tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "tenacity" do
    url "https://files.pythonhosted.org/packages/89/3c/253e1627262373784bf9355db9d6f20d2d8831d79f91e9cca48050cddcc2/tenacity-8.2.3.tar.gz"
    sha256 "5398ef0d78e63f40007c1fb4c0bff96e1911394d2fa8d194f77619c05ff6cc8a"
  end

  resource "tokenizers" do
    url "https://files.pythonhosted.org/packages/48/04/2071c150f374aab6d5e92aaec38d0f3c368d227dd9e0469a1f0966ac68d1/tokenizers-0.19.1.tar.gz"
    sha256 "ee59e6680ed0fdbe6b724cf38bd70400a0c1dd623b07ac729087270caeac88e3"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/5a/c0/b7599d6e13fe0844b0cda01b9aaef9a0e87dbb10b06e4ee255d3fa1c79a2/tqdm-4.66.4.tar.gz"
    sha256 "e4d936c9de8727928f3be6079590e97d9abfe8d39a590be678eb5919ffc186bb"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/ac/0a/d55af35db5f50f486e3eda0ada747eed773859e2699d3ce570b682a9b70a/typer-0.12.3.tar.gz"
    sha256 "49e73131481d804288ef62598d97a1ceef3058905aa536a1134f90891ba35482"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/f3/b827b3ab53b4e3d8513914586dcca61c355fa2ce8252dea4da56e67bf8f2/typing_extensions-4.11.0.tar.gz"
    sha256 "83f085bd5ca59c80295fc2a82ab5dac679cbe02b9f33f7d83af68e241bea51b0"
  end

  resource "ujson" do
    url "https://files.pythonhosted.org/packages/6e/54/6f2bdac7117e89a47de4511c9f01732a283457ab1bf856e1e51aa861619e/ujson-5.9.0.tar.gz"
    sha256 "89cc92e73d5501b8a7f48575eeb14ad27156ad092c2e9fc7e3cf949f07e75532"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/7a/50/7fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79/urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/49/8d/5005d39cd79c9ae87baf7d7aafdcdfe0b13aa69d9a1e3b7f1c984a2ac6d2/uvicorn-0.29.0.tar.gz"
    sha256 "6a69214c0b6a087462412670b3ef21224fa48cae0e452b5883e8e8bdfdd11dd0"
  end

  resource "uvloop" do
    url "https://files.pythonhosted.org/packages/9c/16/728cc5dde368e6eddb299c5aec4d10eaf25335a5af04e8c0abd68e2e9d32/uvloop-0.19.0.tar.gz"
    sha256 "0246f4fd1bf2bf702e06b0d45ee91677ee5c31242f39aab4ea6fe0c51aedd0fd"
  end

  resource "watchfiles" do
    url "https://files.pythonhosted.org/packages/66/79/0ee412e1228aaf6f9568aa180b43cb482472de52560fbd7c283c786534af/watchfiles-0.21.0.tar.gz"
    sha256 "c76c635fabf542bb78524905718c39f736a98e5ab25b23ec6d4abede1a85a6a3"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/e6/30/fba0d96b4b5fbf5948ed3f4681f7da2f9f64512e1d303f94b4cc174c24a5/websocket_client-1.8.0.tar.gz"
    sha256 "3239df9f44da632f96012472805d40a23281a991027ce11d2f45a6f24ac4c3da"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/2e/62/7a7874b7285413c954a4cca3c11fd851f11b2fe5b4ae2d9bee4f6d9bdb10/websockets-12.0.tar.gz"
    sha256 "81df9cbcbb6c260de1e007e58c011bfebe2dafc8435107b0537f393dd38c8b1b"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/95/4c/063a912e20bcef7124e0df97282a8af3ff3e4b603ce84c481d6d7346be0a/wrapt-1.16.0.tar.gz"
    sha256 "5f370f952971e7d17c7d1ead40e49f32345a7f7a5373571ef44d800d06b1899d"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/3e/ef/65da662da6f9991e87f058bc90b91a935ae655a16ae5514660d6460d1298/zipp-3.18.1.tar.gz"
    sha256 "2884ed22e7d8961de1c9a05142eb69a247f120291bc0206a00a7642f09b5b715"
  end

  def install
    virtualenv_create(libexec, "python3")
    virtualenv_install_with_resources
  end

  test do

    # Test basic functionality
    assert_match "yt_fts version: 0.1.47", shell_output("#{bin}/yt-fts --version")

  end
end

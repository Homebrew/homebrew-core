class RapidMlx < Formula
  include Language::Python::Virtualenv

  desc "Fast local AI engine for Apple Silicon with an OpenAI-compatible API"
  homepage "https://github.com/raullenchai/Rapid-MLX"
  url "https://files.pythonhosted.org/packages/8e/fc/95989c90e78009ea19efba3008a992f5ab1cafa5fe683843ddb50b72d76c/rapid_mlx-1.0.3.tar.gz"
  sha256 "9eef4e021e379bdf3fa27b4de8898f19e86a299bf1fea109b681ea16005bfe51"
  license "Apache-2.0"

  no_autobump! because: "macOS resources cannot be updated on linux CI"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e5a0524f3a5d7b3a7c1bf7d4955288eb0a88a2b023b89f051f020250f8c180a9"
    sha256 cellar: :any, arm64_tahoe:       "2d179c05affc732dcbc4b28c59a9264eea64a44fed550d4f86674e5dfdfa3d29"
    sha256 cellar: :any, arm64_sequoia:     "4ba262ce2cd8885c3c30b38d9b13404580057484d9437745ab8e9532cba40269"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "ffmpeg"
  depends_on "libsndfile"
  depends_on "libyaml"
  depends_on macos: :sonoma
  depends_on "mlx"
  depends_on "numpy"
  depends_on "opencv" => :no_linkage
  depends_on "pillow" => :no_linkage
  depends_on "portaudio"
  depends_on "pydantic" => :no_linkage
  depends_on "python-matplotlib" => :no_linkage
  depends_on "python@3.15"
  depends_on "pytorch" => :no_linkage
  depends_on "rpds-py" => :no_linkage
  depends_on "scipy" => :no_linkage
  depends_on "sentencepiece" => :no_linkage
  depends_on "torchvision" => :no_linkage

  # mflux only requires hf-transfer to avoid an error in huggingface-hub < 1.0, which no longer uses it.
  pypi_packages exclude_packages: %w[
    certifi cryptography hf-transfer matplotlib mlx numpy opencv-python pillow pydantic rpds-py scipy
    sentencepiece torch torchvision
  ]

  resource "annotated-doc" do
    url "https://files.pythonhosted.org/packages/0f/6e/a61e86e43bb6039b31a33a8f5fba76fe1cdacf3661e7b9756d4ff1b28cdc/annotated_doc-0.0.6.tar.gz"
    sha256 "7969bb69912085b2285849c0dcac0b4b374fd180c13cf10a87f284ffcf347bbf"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/a1/98/7e457a3b014976887a050561955c0b76e1e7e2d6e27b78ecef2ef80518f2/anyio-4.16.0.tar.gz"
    sha256 "59bb03251907983d1603d27c3087ddb1e93299ea2163adcdba37899a4fb12ffb"
  end

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/87/6f/5a73f04007ca950701765949209f068da628bd11f9c2da287278ce91e0ee/argcomplete-3.7.2.tar.gz"
    sha256 "aad8b69a0b9969edb62db0d1752354c0d50717b10e0cbb00e2a958381b9fc6b9"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/33/1c/f41d4e74c28ab327ff3acd36053f7ea506c55872d7a90b0fa71aa3ab0c89/charset_normalizer-3.5.2.tar.gz"
    sha256 "39de2a259fc954455c57274dc94c79d5842774e1247a016aff30bc0efed0f4ef"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/45/37/edbf1b0707709013c0cf2e8317e03d97ed29bf4cac709fe328904ae92a38/click-8.5.1.tar.gz"
    sha256 "9bbfada76703fd1d784b83eea012e3e8c6a001a876543ef104fa56aaaeb072b4"
  end

  resource "fastapi" do
    url "https://files.pythonhosted.org/packages/4e/7b/ae546e10f153fcf9a6afd8b9fe4730bdfeb8fdcb93178d54122973ef3f4c/fastapi-0.162.5.tar.gz"
    sha256 "1ca37f64f61c99cebd38636e67525fb721c5e8c1169f07f2a35d73b0a63265d4"
  end

  resource "genai-prices" do
    url "https://files.pythonhosted.org/packages/1d/ce/7b18aeb714493736513bffd919414551324cb73f0a4ac8d6f5ddc2373e6d/genai_prices-0.2.3.tar.gz"
    sha256 "cdee9b0b2e44b1323c477ebe3c84e44ddbcdd1a3feb0ebce5bb2af1bc667d900"
  end

  resource "griffelib" do
    url "https://files.pythonhosted.org/packages/36/e2/0f5d8ed08766bc6dcd3eebf5a6623d83cbca33a6e4c90aef57156ce745ad/griffelib-2.4.1.tar.gz"
    sha256 "40c028dd2e623f464423f0e11e3c553158f1cf4f1368239a370534d73e1407ff"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "hf-xet" do
    url "https://files.pythonhosted.org/packages/2f/18/d91c20f815df6cc496a5d0ad8db6d274dad5c0cfcd59babfa2440a9aba44/hf_xet-1.8.0.tar.gz"
    sha256 "10ed23b51dacf7917d64f335c25048deb470efa755e9989b218fc0531386138e"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httpcore2" do
    url "https://files.pythonhosted.org/packages/c0/61/afa9d6b7452f9eca73f73d45324eb0bb52f098fd5e6049bf6b8263be9b4e/httpcore2-2.16.0.tar.gz"
    sha256 "c72cd0413563b17e1cd8354677dff887466f8ec2551679759e93126534428643"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "httpx-sse" do
    url "https://files.pythonhosted.org/packages/0f/4c/751061ffa58615a32c31b2d82e8482be8dd4a89154f003147acee90f2be9/httpx_sse-0.4.3.tar.gz"
    sha256 "9b1ed0127459a66014aec3c56bebd93da3c1bc8bb6618c8082039a44889a755d"
  end

  resource "httpx2" do
    url "https://files.pythonhosted.org/packages/43/73/5ca2cedf5e4e50423d1c258877865a6b62793633b561c58499f8aeb33b7e/httpx2-2.16.0.tar.gz"
    sha256 "0d54c98128e8f2ff7fbbde0fca8c359e5f032edeaaaac443cdb7f31f685bcd7f"
  end

  resource "huggingface-hub" do
    url "https://files.pythonhosted.org/packages/25/2a/484d112c0d8fc5f665d7b65137ac9cdb2953c982391598c3597968a12ee7/huggingface_hub-1.33.0.tar.gz"
    sha256 "367be21a201db9523eddf8aeac7048f2602c1b308691c97640d5e72ed188007e"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "imageio" do
    url "https://files.pythonhosted.org/packages/f3/cd/69e4ac55b6dafdd2b5f32075236841a3945dea7323d0232d80f28c37cea8/imageio-2.38.1.tar.gz"
    sha256 "6769f1f01c4dd46448307863a787c9a22fa4dbe11c0c88f525c6e410fdfd7983"
  end

  resource "imageio-ffmpeg" do
    url "https://files.pythonhosted.org/packages/58/b9/f5887f8fed3f2c145a01a91580f83671ae6753be28fc55ba753bb8a794fc/imageio_ffmpeg-0.8.1.tar.gz"
    sha256 "9e5162fa482c3c45a6703b2223947d15c37730e63b048d64937fa80243aa5a0c"
  end

  resource "jiter" do
    url "https://files.pythonhosted.org/packages/67/de/8dfd06a2153d8ab6a83a8ca8f8ae3ff860ce2fe324ee6a5d05294b621c2a/jiter-0.19.0.tar.gz"
    sha256 "ba3064f8be276d7cfb83c2fb85c858be533da2c2f80f9b048c3781b45a57a195"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/b3/fc/e067678238fa451312d4c62bf6e6cf5ec56375422aee02f9cb5f909b3047/jsonschema-4.26.0.tar.gz"
    sha256 "0c26707e2efad8aa1bfc5b7ce170f3fccc2e4918ff85989ba9ffa9facb2be326"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/19/74/a633ee74eb36c44aa6d1095e7cc5569bebf04342ee146178e2d36600708b/jsonschema_specifications-2025.9.1.tar.gz"
    sha256 "b540987f239e745613c7a9176f3edb72b832a4ac465cf02712288397832b5e8d"
  end

  resource "llguidance" do
    url "https://files.pythonhosted.org/packages/1e/2e/3b0e13c1e01d5598708a6e7b77c55f3ae9c6c4e242a50a239f03ee800630/llguidance-1.9.1.tar.gz"
    sha256 "3ba1b37585d07f50bb73e06dca6d45c88c9d5801789c071c8ff784c9dbcc5c46"
  end

  resource "logfire-api" do
    url "https://files.pythonhosted.org/packages/75/86/00b6bd2e60ac09b26c6e147da48d83dc8706defc2ebde8b003ce6de2b059/logfire_api-5.6.0.tar.gz"
    sha256 "e2341041ebe7bb0283d41e5defa03655f04706b2eeede9b89b6fc23b955ee565"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/16/fc/cee2c45553c9a9bf77d8b0c391560c556d7ed756b1f0bb35eb5d48db09ea/markdown_it_py-4.3.0.tar.gz"
    sha256 "91a58fa5b72c71a40cf7177250fd767480d7a2bb3ac426ccfb76fb90305fdaaa"
  end

  resource "mcp" do
    url "https://files.pythonhosted.org/packages/ba/93/0142dc84a666daf8ad51a34268f34c12fd6fda4f3810c4be2504eecc8212/mcp-1.30.0.tar.gz"
    sha256 "445414625fce5c295faa505bb11bacece661ab6f4028d57c935db57820b7a3e4"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "mflux" do
    url "https://files.pythonhosted.org/packages/7f/08/33ff2acce0f84e51f6c86b6a8d33b4e6703ef485a5d9c40a9e1ebe9af797/mflux-0.20.0.tar.gz"
    sha256 "8fec3407bbc821cfba9cebd8ae55e35450b9429ec9b5445c9557aaeb78087de0"
  end

  resource "miniaudio" do
    url "https://files.pythonhosted.org/packages/1b/8b/2da6a5df7be82ff56810bd90fb79ef3574b2ffd121caa168d3cba4498f9d/miniaudio-1.73.tar.gz"
    sha256 "6652da7e60fabde24d4f3b56c062d4be5f3bfb626818c5a2877f2c782d6e2c4f"
  end

  resource "mlx-arsenal" do
    url "https://files.pythonhosted.org/packages/5b/c5/2fc249eb89b2399a4db86c7b60f45aca239a3035e877b2129958ae44dbe1/mlx_arsenal-0.12.1.tar.gz"
    sha256 "2009d801750e6d1b8f9ecbb75e08b2b6e5dd02ccf864a63b518df90da002f940"
  end

  resource "mlx-audio" do
    url "https://files.pythonhosted.org/packages/cc/4a/ea4746d0c14b75d835dd5164d0e8bba19598248cb29831c0c8e8b98310b9/mlx_audio-0.5.9.tar.gz"
    sha256 "ad2862464d2d5b8ab4b9394a226d044e7022da594329427ef16ca8e93c08e6b5"
  end

  resource "mlx-lm" do
    url "https://files.pythonhosted.org/packages/84/94/9a38d6b0c6fcca995b9136c94eb7da1e9c5165652edf228b96b29960fa7a/mlx_lm-0.31.3.tar.gz"
    sha256 "61eb0e3ba09444f77f874aff295401d7ccd20b39495cbbce0c782a15474ce733"
  end

  resource "mlx-video-with-audio" do
    url "https://files.pythonhosted.org/packages/a0/df/91a078be06fba6ebd15752465070a133fcb49fc042e2199403641e769435/mlx_video_with_audio-0.1.36.tar.gz"
    sha256 "6c7ea0fd31db8f3f4677f3a0650deb0b558912d889113c31fc51c812acb70c4c"
  end

  resource "mlx-vlm" do
    url "https://files.pythonhosted.org/packages/c0/5b/7c90976c8dd038c1260873d85d0b4270948c06abc0a216f2e15fa3879e9c/mlx_vlm-0.7.2.tar.gz"
    sha256 "6d6305cf4f82be4443c20a7dca74fc1116738ecaece42c0e3ff57ae4aea3e156"
  end

  resource "openai" do
    url "https://files.pythonhosted.org/packages/83/8f/adc3e9f7077c16a2417eebb219df2f5933f4fa532fab143c6bbb1c287c67/openai-3.49.0.tar.gz"
    sha256 "44badf2bea9bcd643dafa0bc4d5a109a14395889219fd68b8560322288196e96"
  end

  resource "openai-harmony" do
    url "https://files.pythonhosted.org/packages/3e/92/2d038d096f29179c7c9571b431f9e739f87a487121901725e23fe338dd9d/openai_harmony-0.0.8.tar.gz"
    sha256 "6e43f98e6c242fa2de6f8ea12eab24af63fa2ed3e89c06341fb9d92632c5cbdf"
  end

  resource "opentelemetry-api" do
    url "https://files.pythonhosted.org/packages/19/14/cf3a6b6448849656e1e5f4e2101f3988dc6789724050096aba1bc5ccf592/opentelemetry_api-1.45.2.tar.gz"
    sha256 "d7b0008e21e5fd61cbe7a7f34ca3b6905a78ab677d9bc395e299359c75cda6b4"
  end

  resource "piexif" do
    url "https://files.pythonhosted.org/packages/fa/84/a3f25cec7d0922bf60be8000c9739d28d24b6896717f44cc4cfb843b1487/piexif-1.1.3.zip"
    sha256 "83cb35c606bf3a1ea1a8f0a25cb42cf17e24353fd82e87ae3884e74a302a5f1b"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/d7/9a/8475be631fb33ca1466915e70fd594c42a4e84b512db650eaa14f90fe75d/platformdirs-4.14.5.tar.gz"
    sha256 "32e9921db7385aa8169bee4fe9501923e5715ba9fb7ea3b9c69b0d8e0639f7a1"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/7d/ea/39b988c938f75cb75d7045b5c69f8bfed47ee2152c8837fb403de29d6fb8/prompt_toolkit-3.0.53.tar.gz"
    sha256 "9ec8a0ad96d5c56148b3f914aa79c1564c3fde5d2e6b876e7bc327e353cf8fa6"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/d9/89/5b8517baa72f84a67b8a307ba953c91057af618bf40bf676f3c03551f8f0/protobuf-7.36.2.tar.gz"
    sha256 "497d0463ff3316681da6c0b9e8d06cb465d61abce00b613ab42226175644d1bb"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/aa/c6/d1ddf4abb55e93cebc4f2ed8b5d6dbad109ecb8d63748dd2b20ab5e57ebe/psutil-7.2.2.tar.gz"
    sha256 "0746f5f8d406af344fd547f1c8daa5f5c33dbc293bb8d6a16d80b4bb88f59372"
  end

  resource "pydantic-ai-slim" do
    url "https://files.pythonhosted.org/packages/cc/c9/a50232708b51eea19100fa515ebf2f4bcf92d1110c0cba0abd0aa1117ec6/pydantic_ai_slim-2.61.0.tar.gz"
    sha256 "fe134b7fb8c65ca1e102bcd4c46bd8253866423f9a639ba7ed2341b6eb34b8f2"
  end

  resource "pydantic-graph" do
    url "https://files.pythonhosted.org/packages/f8/45/c48137400dffe74ab0a414adb3596493890a376e96d96b5508aad80ff929/pydantic_graph-2.61.0.tar.gz"
    sha256 "30e93a073998d8bc90ef2b765a8e9b0dc443cca47eb54da78ed8a6986884752d"
  end

  resource "pydantic-settings" do
    url "https://files.pythonhosted.org/packages/d0/31/21d21e0e38a8f5f7a7f0cde22820117b6d17d6bc36f348129527f915d7f4/pydantic_settings-2.16.2.tar.gz"
    sha256 "3dc08ffabed2bbd5dc2dd55ead7b78b4e4c5cd776aecd04310db5f1224caaf46"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/43/ea/5194e52748b0da83d71e082d75496eaec6e58f419f5e184786ded517e6a9/pyjwt-2.15.1.tar.gz"
    sha256 "4f259e80cdfb6b3fc18a7de51fd1ef9ec79652f25019bae68975ca2468a34df8"
  end

  resource "pypdf" do
    url "https://files.pythonhosted.org/packages/1e/e1/ec8f4d155c997c45917153a5521e60d6ee6389d68abdcbc8e44e564caffc/pypdf-6.21.4.tar.gz"
    sha256 "c8817e3f888d47a087872ded69812c1ef30cacb871d6e053e0c00bbaf0bc2163"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/74/26/2fbeedb218a787a5eea551c7532cac4e009f83d689dd2faa0d0353473f86/python_dotenv-1.2.4.tar.gz"
    sha256 "f0d53e69935a851c0dcc78f3ab7aaccd8cabef0b92382b576b824212902873c0"
  end

  resource "python-multipart" do
    url "https://files.pythonhosted.org/packages/9f/b7/15b905f6142a9a8a68f66900788da1a32e4d4254452783b37ad1eccb0506/python_multipart-0.0.33.tar.gz"
    sha256 "b8112424a6abd162ec08d390565dd113ad699f2fe6fef3c987b8bbcbfe9e390d"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/22/f5/df4e9027acead3ecc63e50fe1e36aca1523e1719559c499951bb4b53188f/referencing-0.37.0.tar.gz"
    sha256 "44aefc3142c5b842538163acb373e24cce6632bd54bdb01b21ad5863489f50d8"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/61/27/a5afeb952577b84ee5fe48b8b9ce47ae662dbb69cc5b76c28eff98f83b1e/regex-2026.11.9.tar.gz"
    sha256 "316a70fbd70e999c9664681cb0eb5b4982b2cc0f623c7c86a8a112e1bd4c6277"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "safetensors" do
    url "https://files.pythonhosted.org/packages/45/06/f955dbbb1859e3bd23c8ac6141af5106e7ad5fedec4a3a6e3d60f94b7001/safetensors-0.8.0.tar.gz"
    sha256 "fabaf3e0f18a6618d9b36560682562157f77c2b71fcffc7b432be2baed9d753d"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "sounddevice" do
    url "https://files.pythonhosted.org/packages/ec/db/0c890e2d9aab9ba284021efc02e1d3aebfecab1b611762d7434602209bcf/sounddevice-0.5.6.tar.gz"
    sha256 "8ec9fbfde2e32f020b167e348f3ab3bac6625a5f15af524d790108ac7147a410"
  end

  resource "soundfile" do
    url "https://files.pythonhosted.org/packages/d2/db/949331952a6fb1c5b12e9de80fd08747966c2039d1a61db4764fbd3981c2/soundfile-0.14.0.tar.gz"
    sha256 "ba1c1a2d618bca5c406647c83b89f07cc8810fa506a50622a6993ba130c1de11"
  end

  resource "sse-starlette" do
    url "https://files.pythonhosted.org/packages/41/43/a232e3cd804293bd4f6d01e8895bc0f6f83ea148d712baf9d783c7d93d23/sse_starlette-3.7.0.tar.gz"
    sha256 "326416da2ab52e9a41b3f409d3ff897eda45aa68c9f3b7b17d0913aab8d219c3"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/48/bb/3d8757f21e9a53d9035c9eb039a777047139a16bfdbedfc7a58241c3d914/starlette-1.10.0.tar.gz"
    sha256 "b8399098d4c1e3522734f7235dc79b1fc967f96cf139c81e0fa30479e0685f9b"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/46/58/8c37dea7bbf769b20d58e7ace7e5edfe65b849442b00ffcdd56be88697c6/tabulate-0.10.0.tar.gz"
    sha256 "e2cfde8f79420f6deeffdeda9aaec3b6bc5abce947655d17ac662b126e48a60d"
  end

  resource "tiktoken" do
    url "https://files.pythonhosted.org/packages/e4/e5/5f3cb2159769d0f4324c0e9e87f9de3c4b1cd45848a96b2eb3566ad5ca77/tiktoken-0.13.0.tar.gz"
    sha256 "c9435714c3a84c2319499de9a300c0e604449dd0799ff246458b3bb6a7f433c1"
  end

  resource "tokenizers" do
    url "https://files.pythonhosted.org/packages/73/6f/f80cfef4a312e1fb34baf7d85c72d4411afde10978d4657f8cdd811d3ccc/tokenizers-0.22.2.tar.gz"
    sha256 "473b83b915e547aa366d1eee11806deaf419e17be16310ac0a14077f1e28f917"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "tomli-w" do
    url "https://files.pythonhosted.org/packages/19/75/241269d1da26b624c0d5e110e8149093c759b7a286138f4efd61a60e75fe/tomli_w-1.2.0.tar.gz"
    sha256 "2dd14fac5a47c27be9cd4c976af5a12d87fb1f0b4512f81d69cce3b35ae25021"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/0d/ea/b2a5bd54b28a324dae8211928b2d730b6547500342c7e6c6dea08bd0a485/tqdm-4.70.1.tar.gz"
    sha256 "cefd0eca11b2a37a3aee776544d4f4ae913f02688135b5556b8788dfa474afc4"
  end

  resource "transformers" do
    url "https://files.pythonhosted.org/packages/2a/92/c50c61da7046bbb59a4d011291aeadcfb4d7980ab36fdb31e93823a3fb93/transformers-5.15.1.tar.gz"
    sha256 "27c996bd9075ddc82d40f8590dfdc81ea45f611bfca477e0db5d7fd257a482f7"
  end

  resource "truststore" do
    url "https://files.pythonhosted.org/packages/ee/9f/c5201d42a484c061e528825fc8e2d565f5abd50a4ced6fb7d29c4ec99b2b/truststore-0.10.5.tar.gz"
    sha256 "30d36967ccaded5cbb38d602c433f53600036c79d502f4533a49b60a03bbefcd"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/6c/aa/0de7986aa1fa856adb961c67345189b97d13f6e250b34ba68884df865f07/typer-0.29.1.tar.gz"
    sha256 "ab6eb3880bf67ce96147734717f9ec333c06f66e361f3ea947d0be43da39f242"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/da/34/30e9280707135d2cfc589dfff3cb796bd07a3aeb1a3e415ba09dd89d7bb4/uvicorn-0.54.0.tar.gz"
    sha256 "a2e33cbfaa0306f8e6b0c13e0cb89d7d7a2da3e62b90c66e18c33d9807b28620"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/ea/01/e5ac23733628a6bbb91913a765fcf55ee8070d8d991bc88fdaaf805052c7/wcwidth-0.9.4.tar.gz"
    sha256 "fd8d57d3cdfe570e3265c8fab1885c24e34ef40889c0759c0c304a19e9835954"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/75/79/590c5f0cc7d1661195aeefccb0e342b79f4c77d368d526d028821a390332/websockets-17.4.tar.gz"
    sha256 "09d3939b70df0c8ad2da145ebd50978bccaee1d565e838b0e7921a34d38571eb"
  end

  def install
    # Work around superenv breaking aws-lc-sys `-O0` needed to build CPU Jitter RNG
    ENV["AWS_LC_SYS_NO_JITTER_ENTROPY"] = "1"
    # `tokenizers`, `hf-xet` and `openai-harmony` build PyO3 extensions through maturin.
    ENV.append_to_rustflags "-C link-arg=-Wl,-undefined,dynamic_lookup"

    venv = virtualenv_install_with_resources(without: "hf-xet")

    # Use brewed portaudio instead of sounddevice's bundled cross-platform libraries.
    sounddevice_lib = venv.site_packages/"_sounddevice_data/portaudio-binaries"
    rm_r sounddevice_lib
    sounddevice_lib.install_symlink formula_opt_lib("portaudio")/shared_library("libportaudio")

    resource("hf-xet").stage do
      # Use native-tls rather than needing to build another rustls + aws-lc
      inreplace %w[xet_client/Cargo.toml xet_data/Cargo.toml xet_pkg/Cargo.toml],
                'default = ["rustls-tls"]', 'default = ["native-tls"]'
      venv.pip_install Pathname.pwd
    end

    # These formulae install their Python modules in separate virtual environments.
    site_packages = Language::Python.site_packages(python3)
    (venv.site_packages/"homebrew-pytorch.pth").write "#{formula_opt_libexec("pytorch")/site_packages}\n"
    (venv.site_packages/"homebrew-torchvision.pth").write "#{formula_opt_libexec("torchvision")/site_packages}\n"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rapid-mlx --version")
    assert_match "qwen3.5-4b-4bit", shell_output("#{bin}/rapid-mlx info qwen3.5-4b-4bit")
    system libexec/"bin/python", "-c", <<~PYTHON
      import cv2, imageio_ffmpeg, torch, torchvision
      imageio_ffmpeg.get_ffmpeg_exe()
    PYTHON
  end
end

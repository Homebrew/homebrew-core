class RapidMlx < Formula
  include Language::Python::Virtualenv

  desc "Fast local AI engine for Apple Silicon with an OpenAI-compatible API"
  homepage "https://github.com/raullenchai/Rapid-MLX"
  url "https://files.pythonhosted.org/packages/9b/82/1cd6f35ae4f63736fb9857dd5653898fdccdb457f5cbf1052413a9b8e18e/rapid_mlx-0.10.15.tar.gz"
  sha256 "4e2822d15c716256bf3fd4b5f212f3a96a5fd5f8f66ae9ecdf2e02ae547442f3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "64e37170a51d286f1321dc9443588ce41a65d416f2442831317d6b434b554190"
    sha256 cellar: :any, arm64_sequoia: "daedb049e8121ecad6e4af9126e1f3936fcc629b868af446da3b4f3d877ed2db"
    sha256 cellar: :any, arm64_sonoma:  "0dcc1035e58f55d2359ebefccee33313c1b5c70b5220a87295800a7704c01a98"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on macos: :sonoma
  depends_on "mlx"
  depends_on "numpy"
  depends_on "openssl@3"
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.14"
  depends_on "rpds-py" => :no_linkage

  pypi_packages exclude_packages: %w[certifi mlx numpy pydantic rpds-py]

  resource "annotated-doc" do
    url "https://files.pythonhosted.org/packages/57/ba/046ceea27344560984e26a590f90bc7f4a75b06701f653222458922b558c/annotated_doc-0.0.4.tar.gz"
    sha256 "fbcda96e87e9c92ad167c2e53839e57503ecfda18804ea28102353485033faa4"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/61/cc/a381afa6efea9f496eff839d4a6a1aed3bfafc7b3ab4b0d1b243a12573dd/anyio-4.14.2.tar.gz"
    sha256 "cfa139f3ed1a23ee8f88a145ddb5ac7605b8bbfd8592baacd7ce3d8bb4313c7f"
  end

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/95/c0/c8e94135e66fabf89a120d9b4b123fe6993506beca6c1938a74c24cfa5fd/argcomplete-3.7.0.tar.gz"
    sha256 "afde224f753f874807b1dc1414e883ab8fe0cda9c04807b6047dcb8e1ac23913"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/57/5f/ff100cae70ebe9d8df1c01a00e510e45d9adb5c1fdda84791b199141de97/cffi-2.1.0.tar.gz"
    sha256 "efc1cdd798b1aaf39b4610bba7aad28c9bea9b910f25c784ccf9ec1fa719d1f9"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/bd/2a/23f34ec9d04624958e137efdc394888716353190e75f25dd22c7a2c7a8aa/charset_normalizer-3.4.9.tar.gz"
    sha256 "673611bbd43f0810bec0b0f028ddeaaa501190339cac411f347ac76917c3ae7b"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/76/d4/81420972a676e8ffea40450d8c8c92943e7218a78fe9b64359836cc9876b/click-8.4.2.tar.gz"
    sha256 "9a6cea6e60b17ebe0a44c5cc636d94f09bd66142c1cd7d8b4cd731c4917a15f6"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/1f/99/d1c90d6041656cc6ee229dc99cd67fd0cd5aec3c5f7d72fffc27cc750054/cryptography-49.0.0.tar.gz"
    sha256 "f89660a348f4f78a92366240a61404e337586ef7f5909a2fef59ca88ef505493"
  end

  resource "fastapi" do
    url "https://files.pythonhosted.org/packages/cd/95/d3f0ae10836324a2eab98a52b61210ac609f08200bf4bb0dc8132d32f78a/fastapi-0.139.2.tar.gz"
    sha256 "333145a6891e9b5b3cfceb69baf817e8240cde4d4588ae5a10bf56ffacb6255e"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/c0/80/8232b582c4b318b817cf1274ba74976b07b34d35ef439b3eb948f98645a1/filelock-3.32.0.tar.gz"
    sha256 "7be2ad23a14607ccc71808e68fe30848aeace7058ace17852f68e2a68e310402"
  end

  resource "fsspec" do
    url "https://files.pythonhosted.org/packages/10/a1/ae4e3e5003468d6391d2c77b6fa1cd73bd5d13511d81c642d7b28ac90ed4/fsspec-2026.6.0.tar.gz"
    sha256 "f5bac145310fe30e16e1471bd6840b2d990d609e872251d7e674241822abf01a"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "hf-xet" do
    url "https://files.pythonhosted.org/packages/63/39/67be8d71f900d9a55761b6022821d6679fb56c64f1b6063d5af2c2606727/hf_xet-1.5.2.tar.gz"
    sha256 "73044bd31bae33c984af832d19c752a0dffb67518fee9ddbd91d616e1101cf47"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "httpx-sse" do
    url "https://files.pythonhosted.org/packages/0f/4c/751061ffa58615a32c31b2d82e8482be8dd4a89154f003147acee90f2be9/httpx_sse-0.4.3.tar.gz"
    sha256 "9b1ed0127459a66014aec3c56bebd93da3c1bc8bb6618c8082039a44889a755d"
  end

  resource "huggingface-hub" do
    url "https://files.pythonhosted.org/packages/df/9b/d3bb4e7d792835daf34dd7091bbc7d7b4e0437d9388f1ea7239cce49f478/huggingface_hub-1.24.0.tar.gz"
    sha256 "18431ff4daae0749aa9ba102fc952e314c98e1d30ebdec5319d85ca0a83e1ae5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cd/63/9496c57188a2ee585e0f1db071d75089a11e98aa86eb99d9d7618fc1edce/idna-3.18.tar.gz"
    sha256 "ffb385a7e039654cef1ab9ef32c6fafe283c0c0467bba1d9029738ce4a14a848"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
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
    url "https://files.pythonhosted.org/packages/da/91/6bc8bb503dc259e46d253b5424385a54fe06c38a4c7a12befe69a3c2455a/llguidance-1.7.6.tar.gz"
    sha256 "db7febbe412ed2015501904646750071d7e00e6df7f85c4b956ad4f206fd2df7"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "mcp" do
    url "https://files.pythonhosted.org/packages/6e/77/9450b8f251a13affb6281997d0523c4615f8a8b35d0b21ff30db3a5aac9d/mcp-1.28.1.tar.gz"
    sha256 "d51e36a5f5644faea4f85ea649bfffa6bc6c26770d42798ad6a3de3d2ba69683"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "mlx-lm" do
    url "https://files.pythonhosted.org/packages/84/94/9a38d6b0c6fcca995b9136c94eb7da1e9c5165652edf228b96b29960fa7a/mlx_lm-0.31.3.tar.gz"
    sha256 "61eb0e3ba09444f77f874aff295401d7ccd20b39495cbbce0c782a15474ce733"
  end

  resource "openai-harmony" do
    url "https://files.pythonhosted.org/packages/3e/92/2d038d096f29179c7c9571b431f9e739f87a487121901725e23fe338dd9d/openai_harmony-0.0.8.tar.gz"
    sha256 "6e43f98e6c242fa2de6f8ea12eab24af63fa2ed3e89c06341fb9d92632c5cbdf"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/da/01/9ef0afd7999eb9badb3a768b4aedd78c86d4c65cfaf1958ab276199e76b4/protobuf-7.35.1.tar.gz"
    sha256 "ce115a26fe0c39a2c29973d914d327e516a6455464489fe3cd1e51a1b354f81a"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/aa/c6/d1ddf4abb55e93cebc4f2ed8b5d6dbad109ecb8d63748dd2b20ab5e57ebe/psutil-7.2.2.tar.gz"
    sha256 "0746f5f8d406af344fd547f1c8daa5f5c33dbc293bb8d6a16d80b4bb88f59372"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/1b/7d/92392ff7815c21062bea51aa7b87d45576f649f16458d78b7cf94b9ab2e6/pycparser-3.0.tar.gz"
    sha256 "600f49d217304a5902ac3c37e1281c9fe94e4d0489de643a9504c5cdfdfc6b29"
  end

  resource "pydantic-settings" do
    url "https://files.pythonhosted.org/packages/5c/b5/8f48e906c3e0205276e8bd8cb7512217a87b2685304d64be27cad5b3019f/pydantic_settings-2.14.2.tar.gz"
    sha256 "c19dd64b19097f1de80184f0cc7b0272a13ae6e170cbf240a3e27e381ed14a5f"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/3b/81/58d0ac84e1ef3a3843791d6954d94c0b33d526c75eeb1efbce9d0a4c4077/pyjwt-2.13.0.tar.gz"
    sha256 "41571c89ca91598c79e8ef18a2d07367d4810fbbd6f637794879baf1b7703423"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/82/ed/0301aeeac3e5353ef3d94b6ec08bbcabd04a72018415dcb29e588514bba8/python_dotenv-1.2.2.tar.gz"
    sha256 "2c371a91fbd7ba082c2c1dc1f8bf89ca22564a087c2c287cd9b662adde799cf3"
  end

  resource "python-multipart" do
    url "https://files.pythonhosted.org/packages/5b/42/55c32bb9b12693c092ad250a0e82edb5b31ddeda6eb772de5f308b3804ad/python_multipart-0.0.32.tar.gz"
    sha256 "be54b7f3fa167bb83e4fcd936b887b708f4e57fe75911c02aebf53efaf8d938e"
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
    url "https://files.pythonhosted.org/packages/20/98/04b13f1ddfb63158025291c02e03eb42fbb7acb51d091d541050eb4e35e8/regex-2026.7.19.tar.gz"
    sha256 "7e77b324909c1617cbb4c668677e2c6ae13f44d7c1de0d4f15f2e3c10f3315b5"
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

  resource "sentencepiece" do
    url "https://files.pythonhosted.org/packages/cc/33/ea3cb3839607eb175da835244a798f797f478c5ddf0e8ecdf57ea85a4c70/sentencepiece-0.2.2.tar.gz"
    sha256 "3d2b5e824b5622038dc7b490897efe05ebbbb9e7350fc142f3ecc8789ef9bdf6"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "sse-starlette" do
    url "https://files.pythonhosted.org/packages/6c/10/a34c656829ffc1c4b22ef36d70d9ebb6b99c020e2aeb17cee5485099f028/sse_starlette-3.4.6.tar.gz"
    sha256 "725f8a1bd6d26ae1b2c9610c0ef5065dfdd496f3988d28adcf8c4b49dc25c627"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/eb/e3/7c1dc7381d9f8ab7d854328ebfa884e62cb3f3d8549ddfd37c7814f42afa/starlette-1.3.1.tar.gz"
    sha256 "05d0213193f2fbaae60e2ecb593b4add4262ad4e46536b54abe36f11a71724e0"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/46/58/8c37dea7bbf769b20d58e7ace7e5edfe65b849442b00ffcdd56be88697c6/tabulate-0.10.0.tar.gz"
    sha256 "e2cfde8f79420f6deeffdeda9aaec3b6bc5abce947655d17ac662b126e48a60d"
  end

  resource "tokenizers" do
    url "https://files.pythonhosted.org/packages/73/6f/f80cfef4a312e1fb34baf7d85c72d4411afde10978d4657f8cdd811d3ccc/tokenizers-0.22.2.tar.gz"
    sha256 "473b83b915e547aa366d1eee11806deaf419e17be16310ac0a14077f1e28f917"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/8c/69/40407dfc835517f058b603dbf37a6df094d8582b015a51eddc988febbcb7/tqdm-4.69.0.tar.gz"
    sha256 "700c5e85dcd5f009dd6222588a29180a193a748247a5d855b4d67db93d79a53b"
  end

  resource "transformers" do
    url "https://files.pythonhosted.org/packages/aa/7c/8240f612819718100a9346dc28dea6a11370c3ca9c8c6eabadd3dea4ef29/transformers-5.12.1.tar.gz"
    sha256 "679ee731c8225347889ad4fb3b2c926a62e9da3b7d284e9d12c791da7272466b"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/37/78/fda3361b56efc27944f24225f6ecd13d96d6fcfe37bd0eb34e2f4c63f9fc/typer-0.27.0.tar.gz"
    sha256 "629bd12ea5d13a17148125d9a264f949eb171fb3f120f9b04d85873cab054fa5"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/a2/65/b7c6c443ccc58678c91e1e973bbe2a878591538655d6e1d47f24ba1c51f3/uvicorn-0.51.0.tar.gz"
    sha256 "f6f4b69b657c312f516dd2d268ab9ae6f254b11e4bac504f37b2ab58b24dd0b0"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/21/f7/bc3a25c5ec26ce62ce487690becc2f3710bbc7b33338f005ad390db0b986/websockets-16.1.1.tar.gz"
    sha256 "db234eda965dcce15df96bb9709f587cd87d4d52aaf0e80e2f34ec04c7670c57"
  end

  def install
    # `tokenizers`, `hf-xet` and `openai-harmony` build PyO3 extensions through maturin.
    ENV.append_to_rustflags "-C link-arg=-Wl,-undefined,dynamic_lookup"

    venv = virtualenv_install_with_resources(without: ["hf-xet", "sentencepiece"])

    resource("sentencepiece").stage do
      # Drop the hardcoded 10.9 target; the vendored abseil needs macOS 10.13+
      inreplace "setup.py", "cflags.append('-mmacosx-version-min=10.9')", ""
      venv.pip_install Pathname.pwd
    end

    resource("hf-xet").stage do
      # Use native-tls instead since building bundled aws-lc is tricky to do indirectly within superenv.
      # Can consider switching if system copy is supported https://github.com/aws/aws-lc-rs/issues/936
      inreplace "xet_client/Cargo.toml", 'default = ["rustls-tls"]', 'default = ["native-tls"]'

      # Disable sha2-asm which requires a minimum of -march=armv8-a+crypto
      if ENV.effective_arch == :armv8
        inreplace "xet_data/Cargo.toml",
                  'sha2 = { workspace = true, features = ["asm"] }',
                  "sha2 = { workspace = true }"
      end
      venv.pip_install Pathname.pwd
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rapid-mlx --version")
    assert_match "qwen3.5-4b-4bit", shell_output("#{bin}/rapid-mlx info qwen3.5-4b-4bit")
  end
end

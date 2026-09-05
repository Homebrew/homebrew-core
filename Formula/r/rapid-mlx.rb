class RapidMlx < Formula
  include Language::Python::Virtualenv

  desc "Fast local AI engine for Apple Silicon with an OpenAI-compatible API"
  homepage "https://github.com/raullenchai/Rapid-MLX"
  url "https://files.pythonhosted.org/packages/79/6e/152eb1a898db0ed708a4df03ba96267943857e482938d215a0aef09d4664/rapid_mlx-0.13.4.tar.gz"
  sha256 "58a1f21964730d56783d678e27676b487543159cb89c166624ace6edcf96a6c3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "996e1da69462a4872535d07515ef931f704372c977c27ccd75bbff437201036c"
    sha256 cellar: :any, arm64_sequoia: "e846f18b754f0323945ff1834d8d7349a0f136e0420bd58263d0883431ddeb3c"
    sha256 cellar: :any, arm64_sonoma:  "91ceb0d20ffd3cd01076b2382afbf9fa133e0c0c984cb299e0b49b1cd3d37d8c"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "libyaml"
  depends_on macos: :sonoma
  depends_on "mlx"
  depends_on "numpy"
  depends_on "openssl@3"
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.14"
  depends_on "rpds-py" => :no_linkage

  pypi_packages exclude_packages: %w[certifi cryptography mlx numpy pydantic rpds-py]

  resource "annotated-doc" do
    url "https://files.pythonhosted.org/packages/5a/8e/38aa427ed5402449e226975b649c5dc73ccadfefeb95e6aecb8f8ea4b6b6/annotated_doc-0.0.5.tar.gz"
    sha256 "c7e58ce09192557605d8bbd92836d7e1d520ac9580096042c0bfd197efacf1bb"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/ea/9a/c15a60547004a3f3cea20296c934f827ddd7bdba225a2e7e9fcb5ec48c80/anyio-4.15.0.tar.gz"
    sha256 "b5c620ed540725e2579c31b17bb995b3bf02c9281c9cace04c7d186380bab85e"
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
    url "https://files.pythonhosted.org/packages/e5/3f/143b048436775b0f76ac3eec145c019e8173ccc2885c8f20319b996d5e83/charset_normalizer-3.5.1.tar.gz"
    sha256 "6117b84ea48435e5356dc737f5121485c30920ba43375fa7b434fd753df0eac3"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/c7/0e/7fa0ef50764b67090eca4114772a2abf8b6148198475e54c660b97caeee6/click-8.5.0.tar.gz"
    sha256 "ba0d2089de75ea0310e2dde03160e6ca10009947fb95a182f9b54021bb272e34"
  end

  resource "fastapi" do
    url "https://files.pythonhosted.org/packages/8a/02/91e3416a8fdd715abb903a952a6bec7cdd8d14eed55d415fc8595524c319/fastapi-0.141.1.tar.gz"
    sha256 "e8822fc40db1e1858054d7a949a888695bc9bdce70139178e33bd2871a453ca1"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/0a/a0/50c2c0ce5e74d7721bbb1b19a26ebd339aac5878553a6e35308c2f31f935/filelock-3.32.5.tar.gz"
    sha256 "f6a6a28f743f9b95ce19db5abe0f376f75eb56517dff21e1a4751e2657d3e83d"
  end

  resource "fsspec" do
    url "https://files.pythonhosted.org/packages/00/78/f34251dadb8f3921264a1d9b8946f5e542014ee2614b285261b4e40e6775/fsspec-2026.7.0.tar.gz"
    sha256 "c803c40f4cf860b49dea58ee3e1c33cb9c790520e233537e1340049f89b82a88"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "hf-xet" do
    url "https://files.pythonhosted.org/packages/1b/ab/522a2ab67f27971a9d48ca666d4fca85ef7d5282d142e31fd087e27b1bbe/hf_xet-1.6.0.tar.gz"
    sha256 "2e58454a340b3556dfa4972d5451aff4fba8dd42a236600ba1a1d2b1514f0fef"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httpcore2" do
    url "https://files.pythonhosted.org/packages/be/ad/f4f0e57345f1870f3e8cb624e058d7eca6e5a27d33bcc3311d9b618734cd/httpcore2-2.12.0.tar.gz"
    sha256 "9293522bba0aa7c4c8e9e3f040c16575bd8868e155a77fa30c7a9085a5eae648"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "httpx2" do
    url "https://files.pythonhosted.org/packages/7f/f8/579a8b51e42e38ee32647df9f08aa25643ae788e275cc625b199829c4671/httpx2-2.12.0.tar.gz"
    sha256 "7631fe9887a8a2275f4a2540e053aa670fcc50742864a9ae7c66e609fdcf12cf"
  end

  resource "huggingface-hub" do
    url "https://files.pythonhosted.org/packages/64/35/42316e8f6908b6d21bc8df017cc6efba94fb5edbf99b64e28dd142325e20/huggingface_hub-1.29.0.tar.gz"
    sha256 "6ebb385a581435325cf6d5c5b233d5d4bc91175834d99fd65dae14379b36e9ad"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/5f/f7/abb373e5757eaec4b922b92f97ec8d6d7e057cf06778247604fbc4e7c3f3/idna-3.19.tar.gz"
    sha256 "5e0811a4383b21dc5838069f801c4fb62113b7447663d2530d2bd6e77b49bf15"
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
    url "https://files.pythonhosted.org/packages/20/27/972de1ba4c93072fce816b967972e1d18bc48b04b145b5c77b5bd1dc9662/llguidance-1.8.0.tar.gz"
    sha256 "18d1579eabb040e65c870d50c6df19a7bef140c5260d12ad35b7f0dc446312e0"
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
    url "https://files.pythonhosted.org/packages/d4/6e/21fb8e5d579dbe21d96ea4d5034200d46d8bdf2261053b5bd041f3c2f612/mcp-2.1.1.tar.gz"
    sha256 "50b7ba1ebbe117008ea7bdd288234043e69c20b403d6851d19661e6d431a75ef"
  end

  resource "mcp-types" do
    url "https://files.pythonhosted.org/packages/6a/dd/1c4417dc0b722c23a1669032d5f044e41170fe5d4773b488a50fcce98c32/mcp_types-2.1.1.tar.gz"
    sha256 "77dcbe48fba73cca71a673f2646a5f037a017b7a0a07ac89cec1113028890eda"
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

  resource "opentelemetry-api" do
    url "https://files.pythonhosted.org/packages/ee/8b/aa9e2d8b8dfa7c946f7dec5d1f8f6ba8eca062f43509a06bdb5ce93d26c0/opentelemetry_api-1.44.0.tar.gz"
    sha256 "67647e5e9566edcf421166fdf022b3537f818635daa852b289e34604dc6fb33a"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/86/73/f66c748df06e7fe24e658eddd600d19c4b40bad836c97ce2d0ad9851fb6b/protobuf-7.36.1.tar.gz"
    sha256 "d0f6470f0ce2b84e3feaea2d4b816378b37ba4d4aa08a274305373de93e2d524"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/aa/c6/d1ddf4abb55e93cebc4f2ed8b5d6dbad109ecb8d63748dd2b20ab5e57ebe/psutil-7.2.2.tar.gz"
    sha256 "0746f5f8d406af344fd547f1c8daa5f5c33dbc293bb8d6a16d80b4bb88f59372"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/3b/81/58d0ac84e1ef3a3843791d6954d94c0b33d526c75eeb1efbce9d0a4c4077/pyjwt-2.13.0.tar.gz"
    sha256 "41571c89ca91598c79e8ef18a2d07367d4810fbbd6f637794879baf1b7703423"
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
    url "https://files.pythonhosted.org/packages/19/c1/6b30b775c7bcc6cf6506a4d4741c2123e8d99cd50f3fe8cbd731f5fef526/regex-2026.9.3.tar.gz"
    sha256 "aabd43208e335f4c3f0b56de3464b066dd425983a58f6eeb5738bcd7465403db"
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
    url "https://files.pythonhosted.org/packages/f8/00/b42a44342a054d58cb1115d7c8aa9cb4290dd9442f9c1b91a4b8173dba22/sse_starlette-3.4.8.tar.gz"
    sha256 "ed89ffbb75cbf78a5fe2f2109cd584792ee7f9dfac96f791db546df8f15f3f9c"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/b5/b4/205b0d5241d934e8add0c38aa924c4f9fb7330834ff11e5444db964ec3f9/starlette-1.6.0.tar.gz"
    sha256 "d4e3ac5e546444960c710297a3c9fc3f7ebae1b7e963f3d36173b49da535be9b"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/46/58/8c37dea7bbf769b20d58e7ace7e5edfe65b849442b00ffcdd56be88697c6/tabulate-0.10.0.tar.gz"
    sha256 "e2cfde8f79420f6deeffdeda9aaec3b6bc5abce947655d17ac662b126e48a60d"
  end

  resource "tokenizers" do
    url "https://files.pythonhosted.org/packages/73/6f/f80cfef4a312e1fb34baf7d85c72d4411afde10978d4657f8cdd811d3ccc/tokenizers-0.22.2.tar.gz"
    sha256 "473b83b915e547aa366d1eee11806deaf419e17be16310ac0a14077f1e28f917"
  end

  resource "tomli-w" do
    url "https://files.pythonhosted.org/packages/19/75/241269d1da26b624c0d5e110e8149093c759b7a286138f4efd61a60e75fe/tomli_w-1.2.0.tar.gz"
    sha256 "2dd14fac5a47c27be9cd4c976af5a12d87fb1f0b4512f81d69cce3b35ae25021"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/21/3b/6c24bec5be5e743ffd99576daa5cc077722fc7d5bbc00bd133fa0c698dc6/tqdm-4.70.0.tar.gz"
    sha256 "55b0b0dbd97462d06ebee91e4dac24ed4d4702be82b24f07e6c1d27e08cea220"
  end

  resource "transformers" do
    url "https://files.pythonhosted.org/packages/2a/92/c50c61da7046bbb59a4d011291aeadcfb4d7980ab36fdb31e93823a3fb93/transformers-5.15.1.tar.gz"
    sha256 "27c996bd9075ddc82d40f8590dfdc81ea45f611bfca477e0db5d7fd257a482f7"
  end

  resource "truststore" do
    url "https://files.pythonhosted.org/packages/53/a3/1585216310e344e8102c22482f6060c7a6ea0322b63e026372e6dcefcfd6/truststore-0.10.4.tar.gz"
    sha256 "9d91bd436463ad5e4ee4aba766628dd6cd7010cf3e2461756b3303710eebc301"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/16/f7/57713ba479fd405eb76de31404b2c744c289e336b2d999511ebf51e496f7/typer-0.27.2.tar.gz"
    sha256 "269b7eb9d3c202ca84b4bc9618cb04ebb43d3d4d1e567e4c768607232c05f945"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/f2/0f/3f86e61397dd33bf2ccf28188c40db6a740658aeebbbf6e7dbc101a1f487/uvicorn-0.52.4.tar.gz"
    sha256 "73acfee47a0b133c5de13d219492d62d8a31e935f4fe6e41a232451a15379f86"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/18/72/fba934cb3dff7a85d811820efffcd141ddd52b5a2a01637f64551373ff4d/websockets-17.1.tar.gz"
    sha256 "acfea4c20bf54384883ea33b1240fc1db4f52e190823a4e2b334bc3e8bfca96a"
  end

  def install
    # Work around superenv breaking aws-lc-sys `-O0` needed to build CPU Jitter RNG
    ENV["AWS_LC_SYS_NO_JITTER_ENTROPY"] = "1"
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

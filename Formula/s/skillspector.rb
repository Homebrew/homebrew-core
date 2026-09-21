class Skillspector < Formula
  include Language::Python::Virtualenv

  desc "Security scanner for AI agent skills"
  homepage "https://github.com/NVIDIA/SkillSpector"
  url "https://github.com/NVIDIA/SkillSpector/archive/refs/tags/v2.11.2.tar.gz"
  sha256 "be47a3c40ed84ff3df768bf4fa3200b7cf69cda3f091e854e72ef8fb4b11281e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "89bcaaaf84cc5081f62212f59743e8659cf9c3b52b04287fe4ec8b8492f1bd00"
    sha256 cellar: :any, arm64_tahoe:       "d19d132190e73b769197df8e08bc1f5d7ae25a4805e662258921247f0dc9cabd"
    sha256 cellar: :any, arm64_sequoia:     "d9a0e818ffc7e3ccd11e3d6663130f94d8eab0fd14caa77453a3e4ec3639774f"
    sha256 cellar: :any, arm64_sonoma:      "e0014e478fe9a2b046012b1758ead09ae95133b6bfc8dcf424222d42251ca8d6"
    sha256 cellar: :any, arm64_linux:       "f6043b9156a323cc3ef97f98a27141037a94a8d01c9540273a59a92238073421"
    sha256 cellar: :any, x86_64_linux:      "4c5177ec8312fb3482139773534f82c825e5921994ccf07d9856373c885ebc27"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "libyaml"
  depends_on "numpy"
  depends_on "openssl@3"
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.14"
  depends_on "xxhash"
  depends_on "zstd"

  pypi_packages exclude_packages: %w[certifi cryptography numpy pydantic]

  resource "annotated-doc" do
    url "https://files.pythonhosted.org/packages/5a/8e/38aa427ed5402449e226975b649c5dc73ccadfefeb95e6aecb8f8ea4b6b6/annotated_doc-0.0.5.tar.gz"
    sha256 "c7e58ce09192557605d8bbd92836d7e1d520ac9580096042c0bfd197efacf1bb"
  end

  resource "anthropic" do
    url "https://files.pythonhosted.org/packages/75/6d/793f5cfe2cd444c43b4eeb4cb7c3cc55ebcb38929fdfe81aa1f2fced7326/anthropic-1.4.0.tar.gz"
    sha256 "f0d017e901e48b343520b5d458f8240c283c8d850bf6d119834c622207e0a74c"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/a9/d2/f4d173e22df740bc37b1db102b386ba719b66e95b0f0d751f556b387e6d2/anyio-4.15.1.tar.gz"
    sha256 "9f28306018cbd6d329e64a36d58256edff76dd996fe423bc957326e578b82a94"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/67/0b/53f833efea7331aab106a65f1156e0035beed9bacbfcb309b128204468d4/boto3-1.43.90.tar.gz"
    sha256 "4b669742d5b45b8fd20ca50ac414a4e4cf995ebb8f280d21be28676e71c97594"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/6b/3e/29872261075d878581a31e9e98c512c0b85322a36e6d6784b9f0694a918d/botocore-1.43.90.tar.gz"
    sha256 "a139ed601e8b8fb1d730022355fe2b284b8c15cfe9ac0f100254a35d2273e1d3"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e5/3f/143b048436775b0f76ac3eec145c019e8173ccc2885c8f20319b996d5e83/charset_normalizer-3.5.1.tar.gz"
    sha256 "6117b84ea48435e5356dc737f5121485c30920ba43375fa7b434fd753df0eac3"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/c7/0e/7fa0ef50764b67090eca4114772a2abf8b6148198475e54c660b97caeee6/click-8.5.0.tar.gz"
    sha256 "ba0d2089de75ea0310e2dde03160e6ca10009947fb95a182f9b54021bb272e34"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/fc/f8/98eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3/distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "docstring-parser" do
    url "https://files.pythonhosted.org/packages/e0/4d/f332313098c1de1b2d2ff91cf2674415cc7cddab2ca1b01ae29774bd5fdf/docstring_parser-0.18.0.tar.gz"
    sha256 "292510982205c12b1248696f44959db3cdd1740237a968ea1e2e7a900eeb2015"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
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

  resource "idna" do
    url "https://files.pythonhosted.org/packages/5f/f7/abb373e5757eaec4b922b92f97ec8d6d7e057cf06778247604fbc4e7c3f3/idna-3.19.tar.gz"
    sha256 "5e0811a4383b21dc5838069f801c4fb62113b7447663d2530d2bd6e77b49bf15"
  end

  resource "jiter" do
    url "https://files.pythonhosted.org/packages/1d/1f/10936e16d8860c70698a1aa939a46aa0224813b782bce4e000e637da0b2d/jiter-0.16.0.tar.gz"
    sha256 "7b24c3492c5f4f84a37946ad9cf504910cf6a782d6a4e0689b6673c5894b4a1c"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/d3/59/322338183ecda247fb5d1763a6cbe46eff7222eaeebafd9fa65d4bf5cb11/jmespath-1.1.0.tar.gz"
    sha256 "472c87d80f36026ae83c6ddd0f1d05d4e510134ed462851fd5f754c8c3cbb88d"
  end

  resource "jsonpatch" do
    url "https://files.pythonhosted.org/packages/42/78/18813351fe5d63acad16aec57f94ec2b70a09e53ca98145589e185423873/jsonpatch-1.33.tar.gz"
    sha256 "9fcd4009c41e6d12348b4a0ff2563ba56a2923a7dfee731d004e212e1ee5030c"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/18/c7/af399a2e7a67fd18d63c40c5e62d3af4e67b836a2107468b6a5ea24c4304/jsonpointer-3.1.1.tar.gz"
    sha256 "0b801c7db33a904024f6004d526dcc53bbb8a4a0f4e32bfd10beadf60adf1900"
  end

  resource "langchain-anthropic" do
    url "https://files.pythonhosted.org/packages/81/28/94fa0b41c1dc70fc177d83ea5b48917651cc24da208d236bdebbe3600b8f/langchain_anthropic-1.7.1.tar.gz"
    sha256 "ac087159e1356ae933d5443ded2bca72912a2ed34ea171520fcfdaddfb838687"
  end

  resource "langchain-aws" do
    url "https://files.pythonhosted.org/packages/96/da/d662353d32116112b7a480734e322ebd14e7bff79fc3a2e6e3de23c33413/langchain_aws-1.7.5.tar.gz"
    sha256 "90f50d10c0e55ebbf0a5151304d121a39975cc3e099aad5526e0ee37ea2eeb14"
  end

  resource "langchain-core" do
    url "https://files.pythonhosted.org/packages/89/7b/406b4a8dd43dd01f69e04aafdee206809a2097134b2f944e12802eae7948/langchain_core-1.6.2.tar.gz"
    sha256 "1ec6d3a98f7c8cdbb5bb0deff86e7ca37e16bf4f8f49f022d10723656c62352d"
  end

  resource "langchain-openai" do
    url "https://files.pythonhosted.org/packages/b6/f3/18aeffe267f08c02041114ac42631bcbb2db02bfd538079826f88847fd34/langchain_openai-1.6.1.tar.gz"
    sha256 "a09c329d6d9c5b5bf7025c0d5a5cc8e7ec8d784d662861809e1ec1cce1cd3d26"
  end

  resource "langchain-protocol" do
    url "https://files.pythonhosted.org/packages/14/56/913599f2f9cec8524868929f12d72b2ede377a6056ca8a40a32bdadfa535/langchain_protocol-0.0.19.tar.gz"
    sha256 "79d90a1425122ac87e8052e2ec054fbd09c3edbf341bdfb6397112a495c7bf8c"
  end

  resource "langgraph" do
    url "https://files.pythonhosted.org/packages/56/0d/c8e7ee98896659e1b6555db0ab115a9ca899844744645d5d894032bab1d7/langgraph-1.2.11.tar.gz"
    sha256 "9ecfe11e50d338b34b15cf4d8a442642de103e8ae6971320efba84e4542eb363"
  end

  resource "langgraph-checkpoint" do
    url "https://files.pythonhosted.org/packages/dc/e1/089c4c9e0a2fec7f883f82ae8e6a727138d50074cfeb6644bc2d13b1019b/langgraph_checkpoint-4.2.0.tar.gz"
    sha256 "51a593b6bee684b0818e5d6e58e28ab340c6db7794575056ce7bd1b746a84ed7"
  end

  resource "langgraph-prebuilt" do
    url "https://files.pythonhosted.org/packages/29/66/ed9b93f56bc17ef22d551892f0ac2b225a97fe0fcf23a511b857f70d590b/langgraph_prebuilt-1.1.0.tar.gz"
    sha256 "3c579cf6eed2d17f9c157c2d0fcaddcd8688524e7022d3b22b37a3bf4589d528"
  end

  resource "langgraph-sdk" do
    url "https://files.pythonhosted.org/packages/3f/ae/91446c1fffa04a2dc1f81afbfb5bfff3590452891a72bd9098a656ab2657/langgraph_sdk-0.4.4.tar.gz"
    sha256 "4e651ffa09de695681579396375377bdde23bedbc8e35b070e615cbd5af7da8b"
  end

  resource "langsmith" do
    url "https://files.pythonhosted.org/packages/f4/b7/74d0992a461eacad8106e5dcfd7677d7640b5ff4e12ea545856467004f4f/langsmith-0.12.2.tar.gz"
    sha256 "ff369ba4390e0969dbb109e838281404ae637e76ef73b347336bae05b4f87331"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "openai" do
    url "https://files.pythonhosted.org/packages/14/77/3508ca0f04f42124bb89ab6e3e853c144660b9a680165beb49cd48634bce/openai-3.9.0.tar.gz"
    sha256 "fea0fe63d04a27e9da588f673e291183fbf4813767e9df743e351bb548afc60b"
  end

  resource "orjson" do
    url "https://files.pythonhosted.org/packages/0f/f3/742fb1f62b825f2c010697eaf4e828004bc2a81e7e806666989c132c7c42/orjson-3.12.0.tar.gz"
    sha256 "d14203fb1aae2ad9b3d52f8a0e82aeb10197ef1c9bc61da7f358bd70b00123d5"
  end

  resource "ormsgpack" do
    url "https://files.pythonhosted.org/packages/12/0c/f1761e21486942ab9bb6feaebc610fa074f7c5e496e6962dea5873348077/ormsgpack-1.12.2.tar.gz"
    sha256 "944a2233640273bee67521795a73cf1e959538e0dfb7ac635505010455e53b33"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pywhatwgurl" do
    url "https://files.pythonhosted.org/packages/c0/d2/ce0fffb9eb66ea2f88d20d7c3841b017d25559b6b617bce566811fe0bb48/pywhatwgurl-0.1.1.tar.gz"
    sha256 "65c85da35367511c12a4dd87fecaf08aa3ae564259055b37b4ae53429289fcf6"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/dc/0e/49aee608ad09480e7fd276898c99ec6192985fa331abe4eb3a986094490b/regex-2026.5.9.tar.gz"
    sha256 "a8234aa23ec39894bfe4a3f1b85616a7032481964a13ac6fc9f10de4f6fca270"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "requests-toolbelt" do
    url "https://files.pythonhosted.org/packages/f3/61/d7545dafb7ac2230c70d38d31cbfe4cc64f7144dc41f6e4e4b78ecd9f5bb/requests-toolbelt-1.0.0.tar.gz"
    sha256 "7681a0a3d047012b5bdc0ee37d7f8f07ebe76ab08caeccfc3921ce23c88d5bc6"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/76/43/35e4d8aa320bffe8287fe8f65f578fa2d2db0a64212f0e710dce58267854/s3transfer-0.19.2.tar.gz"
    sha256 "ba0309fd86be3c27dbf78cdd813c13c5e1df16e5874b99d2535ebbdfb9892993"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "tenacity" do
    url "https://files.pythonhosted.org/packages/47/c6/ee486fd809e357697ee8a44d3d69222b344920433d3b6666ccd9b374630c/tenacity-9.1.4.tar.gz"
    sha256 "adb31d4c263f2bd041081ab33b498309a57c77f9acf2db65aadf0898179cf93a"
  end

  resource "tiktoken" do
    url "https://files.pythonhosted.org/packages/66/62/167a842aa0429d45f5e797354fd4343a96f6043d67d0513c675c7b8d36e6/tiktoken-0.14.0.tar.gz"
    sha256 "231dec90efcdccf1b565a1416107736f1e09b1a08fe736ef9d6363e626d03874"
  end

  resource "truststore" do
    url "https://files.pythonhosted.org/packages/53/a3/1585216310e344e8102c22482f6060c7a6ea0322b63e026372e6dcefcfd6/truststore-0.10.4.tar.gz"
    sha256 "9d91bd436463ad5e4ee4aba766628dd6cd7010cf3e2461756b3303710eebc301"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/d3/ae/93d16574e66dfe4c2284ffdaca4b0320ade32858cb2cc586c8dd79f127c5/typer-0.23.2.tar.gz"
    sha256 "a99706a08e54f1aef8bb6a8611503808188a4092808e86addff1828a208af0de"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  resource "uuid-utils" do
    url "https://files.pythonhosted.org/packages/4c/80/cf6934a2030a5f6763f604314c1105f851d90aa1fe344c2692c3b88a9d95/uuid_utils-0.17.1.tar.gz"
    sha256 "10c51d54ecdf0617640e505eae6d2e6443d8e414d4f9d6e8d43949a450c56e6b"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/21/f7/bc3a25c5ec26ce62ce487690becc2f3710bbc7b33338f005ad390db0b986/websockets-16.1.1.tar.gz"
    sha256 "db234eda965dcce15df96bb9709f587cd87d4d52aaf0e80e2f34ec04c7670c57"
  end

  resource "xxhash" do
    url "https://files.pythonhosted.org/packages/f6/a5/1386f35da1475fcaeef42581deae73417c6d2a6a0b2d2e8914de18844dcd/xxhash-4.0.1.tar.gz"
    sha256 "d55bf4ef10eb09b8b6866790e083d26d087d84caa3cc0946ba87c3ca7ecaf7b7"
  end

  resource "yara-python" do
    url "https://files.pythonhosted.org/packages/51/38/347d1fcde4edabd338d5872ca5759ccfb95ff1cf5207dafded981fd08c4f/yara_python-4.5.4.tar.gz"
    sha256 "4c682170f3d5cb3a73aa1bd0dc9ab1c0957437b937b7a83ff6d7ffd366415b9c"
  end

  resource "zstandard" do
    url "https://files.pythonhosted.org/packages/fd/aa/3e0508d5a5dd96529cdc5a97011299056e14c6505b678fd58938792794b1/zstandard-0.25.0.tar.gz"
    sha256 "7713e1179d162cf5c7906da876ec2ccb9c3a9dcbdffef0cc7f70c3667a205f0b"
  end

  def install
    # Link against the keg rather than the copy vendored in the sdist.
    ENV["XXHASH_LINK_SO"] = "1"

    venv = virtualenv_install_with_resources without: "zstandard"

    # zstandard only uses the system libzstd when told to at build time.
    resource("zstandard").stage do
      args = std_pip_args(prefix: false, build_isolation: true)
      args << "--config-settings=--build-option=--system-zstd"
      system venv.root/"bin/python", "-m", "pip", "install", *args, "."
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/skillspector --version")

    (testpath/"SKILL.md").write <<~EOS
      # Test Skill
      This is a test skill for Skillspector.
    EOS

    output = shell_output("#{bin}/skillspector scan SKILL.md --no-llm")
    assert_match "SkillSpector Security Report", output
  end
end

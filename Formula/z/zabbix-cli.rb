class ZabbixCli < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for interacting with Zabbix monitoring system"
  homepage "https://unioslo.github.io/zabbix-cli/"
  url "https://files.pythonhosted.org/packages/73/7e/ea140a7f1f8177025defb394a13c390eeafea6c38dd18dbdafda973ecbd3/zabbix_cli_uio-3.7.1.tar.gz"
  sha256 "d3c78ee64c7dbcfc8c168a1507241651c9fcc1cef857be33e97ccf271a674ba4"
  license "GPL-3.0-or-later"
  head "https://github.com/unioslo/zabbix-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b38571e82b89c35c658c7d727d8bbde2d7fce48ef733b4ddcd58d9d851eb1d27"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bf7fb9e6b9fb465bafdfd6ed9e9a67df2727d9099394d40148d823d3350f3793"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1c2722ac6f63d991a2369e7bb72fd518a2d0479a2af6c5204aaadaa8cff203c5"
    sha256 cellar: :any,                 arm64_linux:       "245e40f0c3c7896eb459656a19c3f45678f5a83da307bf2d45749aab3fc9cebc"
    sha256 cellar: :any,                 x86_64_linux:      "32cf85745d7c2cc5142d77ff7cdcd2b6e15cb45f95122dbcabf81ee22d173826"
  end

  depends_on "certifi" => :no_linkage
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.15"

  pypi_packages package_name:     "zabbix_cli_uio",
                exclude_packages: ["certifi", "pydantic"]

  resource "annotated-doc" do
    url "https://files.pythonhosted.org/packages/5a/8e/38aa427ed5402449e226975b649c5dc73ccadfefeb95e6aecb8f8ea4b6b6/annotated_doc-0.0.5.tar.gz"
    sha256 "c7e58ce09192557605d8bbd92836d7e1d520ac9580096042c0bfd197efacf1bb"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/a9/d2/f4d173e22df740bc37b1db102b386ba719b66e95b0f0d751f556b387e6d2/anyio-4.15.1.tar.gz"
    sha256 "9f28306018cbd6d329e64a36d58256edff76dd996fe423bc957326e578b82a94"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/c7/0e/7fa0ef50764b67090eca4114772a2abf8b6148198475e54c660b97caeee6/click-8.5.0.tar.gz"
    sha256 "ba0d2089de75ea0310e2dde03160e6ca10009947fb95a182f9b54021bb272e34"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/58/e6/d0abbb256b44e6a05748c6942511ff67db8dbb068de0c35b24bf1b395b09/platformdirs-4.13.5.tar.gz"
    sha256 "05831adf87d392760f4b5c3a0a95579ab5a10b18b9b9bd43680dcb47544788a0"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/7d/ea/39b988c938f75cb75d7045b5c69f8bfed47ee2152c8837fb403de29d6fb8/prompt_toolkit-3.0.53.tar.gz"
    sha256 "9ec8a0ad96d5c56148b3f914aa79c1564c3fde5d2e6b876e7bc327e353cf8fa6"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "socksio" do
    url "https://files.pythonhosted.org/packages/f8/5c/48a7d9495be3d1c651198fd99dbb6ce190e2274d0f28b9051307bdec6b85/socksio-1.0.0.tar.gz"
    sha256 "f88beb3da5b5c38b9890469de67d0cb0f9d494b78b106ca1845f96c10b91c4ac"

    # Unpin flit-core<3 to support 3.14+
    patch do
      url "https://github.com/sethmlarson/socksio/commit/b326406915fd98a8185c1c160165c5b8963b30c1.patch?full_index=1"
      sha256 "7aefa906b62e2c9a8df255ea742ca97e155ac2e1238e49ce11e3e56e37ee1f8b"
      type :backport
    end

    # Fix for flit-core>=5
    patch do
      url "https://github.com/sethmlarson/socksio/commit/504f7e51682b9526d3ecc7ea893338af1fedfb2d.patch?full_index=1"
      sha256 "b0c327c4e8fa722669dc372263d735f429015587e02935e2e8cb2b22028c0bfb"
      type :backport
      resolves "https://github.com/sethmlarson/socksio/pull/66"
    end
  end

  resource "strenum" do
    url "https://files.pythonhosted.org/packages/85/ad/430fb60d90e1d112a62ff57bdd1f286ec73a2a0331272febfddd21f330e1/StrEnum-0.4.15.tar.gz"
    sha256 "878fb5ab705442070e4dd1929bb5e2249511c0bcf2b0eeacf3bcd80875c82eff"

    # py3.12 build patch, upstream pr ref, https://github.com/irgeek/StrEnum/pull/34
    patch do
      url "https://github.com/irgeek/StrEnum/commit/896bef1b7e4a50c8b53d90c8d2fb5c0164f08ecd.patch?full_index=1"
      sha256 "1d74618b970b04d5548e9efa9134010812c20a941e26381d71bc21b06cfc667b"
      type :unofficial
      resolves "https://github.com/irgeek/StrEnum/pull/34"
    end
  end

  resource "tomli-w" do
    url "https://files.pythonhosted.org/packages/19/75/241269d1da26b624c0d5e110e8149093c759b7a286138f4efd61a60e75fe/tomli_w-1.2.0.tar.gz"
    sha256 "2dd14fac5a47c27be9cd4c976af5a12d87fb1f0b4512f81d69cce3b35ae25021"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/e4/51/9aed62104cea109b820bbd6c14245af756112017d309da813ef107d42e7e/typer-0.25.1.tar.gz"
    sha256 "9616eb8853a09ffeabab1698952f33c6f29ffdbceb4eaeecf571880e8d7664cc"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/69/4a/82d61476a1ccc20d43d0805724c5de4baa4971131a8db1816705ef53fe16/wcwidth-0.9.3.tar.gz"
    sha256 "dfe7cfbd4cb59db9fe0931bd6091ab4a95b3acc5d56bfb50fa9fef0ccba5dc5c"
  end

  allow_network_access! :build

  def install
    virtualenv_install_with_resources
    generate_completions_from_executable(bin/"zabbix-cli", shell_parameter_format: :typer)
  end

  test do
    assert_match <<~TOML, shell_output("#{bin}/zabbix-cli sample_config")
      [api]
      url = "https://zabbix.example.com"
      username = "Admin"
      password = ""
      auth_token = ""
      verify_ssl = true
    TOML

    assert_match version.to_s, shell_output("#{bin}/zabbix-cli --version")
  end
end

class Tmt < Formula
  include Language::Python::Virtualenv

  desc "Test Management Tool"
  homepage "https://tmt.readthedocs.io"
  url "https://files.pythonhosted.org/packages/d8/33/24042082f226dd18274e51997b2241b3dc2afbbe348ed0cafd5030a9be65/tmt-1.62.1.tar.gz"
  sha256 "d588ed74e26e4379e7fb0ce8b163489ddf5af8de7b7d643bb77616af0b93146e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "69f84f850a8075726504632ffe5d26e9eb4b5db69cbf70c8a9cc345b8f4db16b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e0ee44305e3cd42274ea12bb3a587dc9f05c6f57c1c85e808360d4c486e2c07"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9498aec774e9ed9c498ade5f77c46d5d8cf2e3543628c5a95f9ca61a8de6697"
    sha256 cellar: :any_skip_relocation, sonoma:        "86f5cd756fcfda1eb33c8fb4fe59536db8a8dc0f96483f817763c6aa9993aba4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91f3046e4995d5aeb6ef42fc850882fad4c4a62e29640d1855533dd74b2c5713"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f586069b67f85dd6d82394fb31e713b43bca67a7487d4aa9db7db6ea88d963b3"
  end

  depends_on "beakerlib"
  depends_on "certifi" => :no_linkage
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.14"
  depends_on "rpds-py" => :no_linkage

  pypi_packages exclude_packages: ["certifi", "pydantic", "rpds-py"]

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/6b/5c/685e6633917e101e5dcb62b9dd76946cbb57c26e133bae9e0cd36033c0a9/attrs-25.4.0.tar.gz"
    sha256 "16d5969b87f0859ef33a48b35d55ac1be6e42ae49d5e853b597db70c35c57e11"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/3d/fa/656b739db8587d7b5dfa22e22ed02566950fbfbcdc20311993483657a5c0/click-8.3.1.tar.gz"
    sha256 "12ff4785d337a1bb490bb7e9c2b1ee5da3112e94a8622f26a6c77f5d2fc6842a"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/d9/02/111134bfeb6e6c7ac4c74594e39a59f6c0195dc4846afbeac3cba60f1927/docutils-0.22.3.tar.gz"
    sha256 "21486ae730e4ca9f622677b1412b879af1791efcfba517e4c6f60be543fc8cdd"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/58/46/0028a82567109b5ef6e4d2a1f04a583fb513e6cf9527fcdd09afd817deeb/filelock-3.20.0.tar.gz"
    sha256 "711e943b4ec6be42e1d4e6690b48dc175c822967466bb31c0c293f34334c13f4"
  end

  resource "flexcache" do
    url "https://files.pythonhosted.org/packages/55/b0/8a21e330561c65653d010ef112bf38f60890051d244ede197ddaa08e50c1/flexcache-0.3.tar.gz"
    sha256 "18743bd5a0621bfe2cf8d519e4c3bfdf57a269c15d1ced3fb4b64e0ff4600656"
  end

  resource "flexparser" do
    url "https://files.pythonhosted.org/packages/82/99/b4de7e39e8eaf8207ba1a8fa2241dd98b2ba72ae6e16960d8351736d8702/flexparser-0.4.tar.gz"
    sha256 "266d98905595be2ccc5da964fe0a2c3526fbbffdc45b65b3146d75db992ef6b2"
  end

  resource "fmf" do
    url "https://files.pythonhosted.org/packages/2c/fe/aed3f3befc18d725776c10fe621790002671d0c4d50a6287d71fa371cf90/fmf-1.7.0.tar.gz"
    sha256 "131b557786b912f99d49d8dcc84196e3c2f39c5ce5ffe8b78e48150afd380dc3"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/74/69/f7185de793a29082a9f3c7728268ffb31cb5095131a9c139a74078e27336/jsonschema-4.25.1.tar.gz"
    sha256 "e4a9655ce0da0c0b67a085847e00a3a51449e1157f4f75e9fb5aa545e122eb85"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/19/74/a633ee74eb36c44aa6d1095e7cc5569bebf04342ee146178e2d36600708b/jsonschema_specifications-2025.9.1.tar.gz"
    sha256 "b540987f239e745613c7a9176f3edb72b832a4ac465cf02712288397832b5e8d"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "pint" do
    url "https://files.pythonhosted.org/packages/5f/74/bc3f671997158aef171194c3c4041e549946f4784b8690baa0626a0a164b/pint-0.25.2.tar.gz"
    sha256 "85a45d1da8fe9c9f7477fed8aef59ad2b939af3d6611507e1a9cbdacdcd3450a"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/61/33/9611380c2bdb1225fdef633e2a9610622310fed35ab11dac9620972ee088/platformdirs-4.5.0.tar.gz"
    sha256 "70ddccdd7c99fc5942e9fc25636a8b34d04c24b335100223152c2803e4063312"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/22/f5/df4e9027acead3ecc63e50fe1e36aca1523e1719559c499951bb4b53188f/referencing-0.37.0.tar.gz"
    sha256 "44aefc3142c5b842538163acb373e24cce6632bd54bdb01b21ad5863489f50d8"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/9f/c7/ee630b29e04a672ecfc9b63227c87fd7a37eb67c1bf30fe95376437f897c/ruamel.yaml-0.18.16.tar.gz"
    sha256 "a6e587512f3c998b2225d68aa1f35111c29fad14aed561a26e73fab729ec5e5a"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"tmt", shell_parameter_format: :click)
  end

  test do
    output = shell_output("#{bin}/tmt init --template mini")
    assert_match "Applying template 'mini'", output
    assert_match <<~YAML, (testpath/"plans/example.fmf").read
      summary: Basic smoke test
      execute:
          how: tmt
          script: tmt --help
    YAML

    assert_match version.to_s, pipe_output("#{bin}/tmt --version")
  end
end

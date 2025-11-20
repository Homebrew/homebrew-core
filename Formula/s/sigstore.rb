class Sigstore < Formula
  include Language::Python::Virtualenv

  desc "Codesigning tool for Python packages"
  homepage "https://github.com/sigstore/sigstore-python"
  url "https://files.pythonhosted.org/packages/64/1e/8c115a155b67254b52780730bc86edf90d108d172377e526ce91e42ba9de/sigstore-4.1.0.tar.gz"
  sha256 "312f7f73fe27127784245f523b86b6334978c555fe4ba7831be5602c089807c1"
  license "Apache-2.0"
  head "https://github.com/sigstore/sigstore-python.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "115a445c972a2e6ddc48c0199693841b63cff331e4cec6603ad35f0a9f2d25d2"
    sha256 cellar: :any,                 arm64_sequoia: "15009ae939ad6831bea014a6ea7aaf07f8f32b7b9a286a9f00d2a26c71fa4ec1"
    sha256 cellar: :any,                 arm64_sonoma:  "1a953d72ed5701f4122c5c3e2966d101ac889d1e1b17b8a6c8bf0f6ffceae82b"
    sha256 cellar: :any,                 sonoma:        "28363b205b412b3d9dbe5906a2b862644d694fcc9e1cf17966b466801d7f9d50"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b5ec7cfe20982d08ecaee0c2da8656ea897722f9ae48b706082d50a0ef2624e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43186b918239b114ea87a03b10461d6152bdefe06050813e28cc8cd475ad8cec"
  end

  depends_on "pkgconf" => :build # for rfc3161-client
  depends_on "rust" => :build # for rfc3161-client
  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "openssl@3" # for rfc3161-client
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.14"

  pypi_packages exclude_packages: %w[certifi cryptography pydantic]

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/8c/8b/57666417c0f90f08bcafa776861060426765fdb422eb10212086fb811d26/dnspython-2.8.0.tar.gz"
    sha256 "181d3c6996452cb1189c4046c61599b84a5a86e099562ffde77d26984ff26d0f"
  end

  resource "email-validator" do
    url "https://files.pythonhosted.org/packages/f5/22/900cb125c76b7aaa450ce02fd727f452243f2e91a61af068b40adba60ea9/email_validator-2.3.0.tar.gz"
    sha256 "9fc05c37f2f6cf439ff414f8fc46d917929974a82244c20eb10231ba60c54426"
  end

  resource "id" do
    url "https://files.pythonhosted.org/packages/22/11/102da08f88412d875fa2f1a9a469ff7ad4c874b0ca6fed0048fe385bdb3d/id-1.5.0.tar.gz"
    sha256 "292cb8a49eacbbdbce97244f47a97b4c62540169c976552e497fd57df0734c1d"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/61/33/9611380c2bdb1225fdef633e2a9610622310fed35ab11dac9620972ee088/platformdirs-4.5.0.tar.gz"
    sha256 "70ddccdd7c99fc5942e9fc25636a8b34d04c24b335100223152c2803e4063312"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/ba/e9/01f1a64245b89f039897cb0130016d79f77d52669aae6ee7b159a6c4c018/pyasn1-0.6.1.tar.gz"
    sha256 "6f580d2bdd84365380830acf45550f2511469f673cb4a5ae3857a3170128b034"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/e7/46/bd74733ff231675599650d3e47f361794b22ef3e3770998dda30d3b63726/pyjwt-2.10.1.tar.gz"
    sha256 "3cc5772eb20009233caf06e9d8a0577824723b44e6648ee0a2aedb6cf9381953"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/80/be/97b83a464498a79103036bc74d1038df4a7ef0e402cfaf4d5e113fb14759/pyopenssl-25.3.0.tar.gz"
    sha256 "c981cb0a3fd84e8602d7afc209522773b94c1c2446a3c710a75b06fe1beae329"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "rfc3161-client" do
    url "https://files.pythonhosted.org/packages/85/19/c04a07f9926943b6a6945ae6972dc2c3c79b7f02e2be6346e3010a48d5f5/rfc3161_client-1.0.5.tar.gz"
    sha256 "f1a2e32e2a053455cee1ff9b325b88dbc7c66c8882dde60962add92f572df5c5"
  end

  resource "rfc8785" do
    url "https://files.pythonhosted.org/packages/ef/2f/fa1d2e740c490191b572d33dbca5daa180cb423c24396b856f5886371d8b/rfc8785-0.1.4.tar.gz"
    sha256 "e545841329fe0eee4f6a3b44e7034343100c12b4ec566dc06ca9735681deb4da"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/fb/d2/8920e102050a0de7bfabeb4c4614a49248cf8d5d7a8d01885fbb24dc767a/rich-14.2.0.tar.gz"
    sha256 "73ff50c7c0c1c77c8243079283f4edb376f0f6442433aecb8ce7e6d0b92d1fe4"
  end

  resource "securesystemslib" do
    url "https://files.pythonhosted.org/packages/c2/dd/d1828dce0db18aa8d34f82aee4dbcf49b0f0303cad123a1c716bb1f3bf83/securesystemslib-1.3.1.tar.gz"
    sha256 "ca915f4b88209bb5450ac05426b859d74b7cd1421cafcf73b8dd3418a0b17486"
  end

  resource "sigstore-models" do
    url "https://files.pythonhosted.org/packages/ac/13/f67a87e8d8c97b9a47d4971263ca6afbd5250315a55b8056358061fc07da/sigstore_models-0.0.5.tar.gz"
    sha256 "8eda90fe16ef3e4e624edd029f4cbbc9832a192dc5c8f66011d94ec4253f9f3f"
  end

  resource "sigstore-rekor-types" do
    url "https://files.pythonhosted.org/packages/b4/54/102e772445c5e849b826fbdcd44eb9ad7b3d10fda17b08964658ec7027dc/sigstore_rekor_types-0.0.18.tar.gz"
    sha256 "19aef25433218ebf9975a1e8b523cc84aaf3cd395ad39a30523b083ea7917ec5"
  end

  resource "tuf" do
    url "https://files.pythonhosted.org/packages/25/b5/377a566dfa8286b2ca27ddbc792ab1645de0b6c65dd5bf03027b3bf8cc8f/tuf-6.0.0.tar.gz"
    sha256 "9eed0f7888c5fff45dc62164ff243a05d47fb8a3208035eb268974287e0aee8d"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sigstore -V")

    # NOTE: This resource and below do not needed to be kept up-to-date
    # with the latest sigstore-python release.
    resource "homebrew-test-artifact" do
      url "https://github.com/sigstore/sigstore-python/releases/download/v3.3.0/sigstore-3.3.0.tar.gz", using: :nounzip
      sha256 "931e9913996ceace713d28e2431989414e711af30606f0b1e8bdc30fcbdd3fbe"
    end

    resource "homebrew-test-artifact.sigstore" do
      url "https://github.com/sigstore/sigstore-python/releases/download/v3.3.0/sigstore-3.3.0.tar.gz.sigstore"
      sha256 "1cb946269f563b669183307b603f85169c7b1399835c66b8b4d28d913d26d5f7"
    end

    resource("homebrew-test-artifact").stage testpath
    resource("homebrew-test-artifact.sigstore").stage testpath

    cert_identity = "https://github.com/sigstore/sigstore-python/.github/workflows/release.yml@refs/tags/v3.3.0"

    output = shell_output("#{bin}/sigstore verify github sigstore-3.3.0.tar.gz --cert-identity #{cert_identity} 2>&1")
    assert_match "OK: sigstore-3.3.0.tar.gz", output
  end
end

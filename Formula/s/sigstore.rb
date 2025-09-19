class Sigstore < Formula
  include Language::Python::Virtualenv

  desc "Codesigning tool for Python packages"
  homepage "https://github.com/sigstore/sigstore-python"
  url "https://files.pythonhosted.org/packages/e6/7c/348c9429e2af1358d7dfd71e9f9613de0874e757660990ef9adf96c7a2f1/sigstore-4.0.0.tar.gz"
  sha256 "5a07f7861ef4c30288fd178c73142ba4e7f236da6509c3be8a293cb1e2bea91f"
  license "Apache-2.0"
  head "https://github.com/sigstore/sigstore-python.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "11cc597505bd6231080ad40d6fccaf188c391a9a58c8d8c82b5224cd7efe225d"
    sha256 cellar: :any,                 arm64_sequoia: "ad77baa3cee8d5691dcfaf51af31c0a80e18caf1dbc86d1f22941ee197bcce84"
    sha256 cellar: :any,                 arm64_sonoma:  "87377276118c4a0692609671f66750e1db691e86d69b92a888d78e9ad33c45fe"
    sha256 cellar: :any,                 sonoma:        "d38d18cd8e811aa55ef5727a927667043c9db638ea60da6370211464f359e631"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "685f96ed4d77d1bb28e768421f16015945732407c7a3224853b85dd7738e1919"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1368160cb35b80d9519126271215a9a62a42f71a0ef8271be3b8e29eb28c98eb"
  end

  depends_on "pkgconf" => :build # for rfc3161-client
  depends_on "rust" => :build
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "openssl@3" # for rfc3161-client
  depends_on "python@3.13"

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/ee/67/531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5/annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/83/2d/5fd176ceb9b2fc619e63405525573493ca23441330fcdaee6bef9460e924/charset_normalizer-3.4.3.tar.gz"
    sha256 "6fce4b8500244f6fcb71465d4a4930d132ba9ab8e71a7859e6a5d59851068d14"
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
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
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
    url "https://files.pythonhosted.org/packages/23/e8/21db9c9987b0e728855bd57bff6984f67952bea55d6f75e055c46b5383e8/platformdirs-4.4.0.tar.gz"
    sha256 "ca753cf4d81dc309bc67b0ea38fd15dc97bc30ce419a7f58d13eb3bf14c4febf"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/ba/e9/01f1a64245b89f039897cb0130016d79f77d52669aae6ee7b159a6c4c018/pyasn1-0.6.1.tar.gz"
    sha256 "6f580d2bdd84365380830acf45550f2511469f673cb4a5ae3857a3170128b034"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/ff/5d/09a551ba512d7ca404d785072700d3f6727a02f6f3c24ecfd081c7cf0aa8/pydantic-2.11.9.tar.gz"
    sha256 "6b8ffda597a14812a7975c90b82a8a2e777d9257aba3453f973acd3c032a18e2"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/ad/88/5f2260bdfae97aabf98f1778d43f69574390ad787afb646292a638c923d4/pydantic_core-2.33.2.tar.gz"
    sha256 "7cb8bc3605c29176e1b105350d2e6474142d7c1bd1d9327c4a9bdb46bf827acc"
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
    url "https://files.pythonhosted.org/packages/4d/12/f0dc57325bd9256c7e6878ad458e9077d6a9b08a59b32d158d4e89490c11/rfc3161_client-1.0.4.tar.gz"
    sha256 "019e39699b96b5e92145d915b18a108868ce8c2b8f4e7f25d9ee1ef70ce76f08"
  end

  resource "rfc8785" do
    url "https://files.pythonhosted.org/packages/ef/2f/fa1d2e740c490191b572d33dbca5daa180cb423c24396b856f5886371d8b/rfc8785-0.1.4.tar.gz"
    sha256 "e545841329fe0eee4f6a3b44e7034343100c12b4ec566dc06ca9735681deb4da"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/fe/75/af448d8e52bf1d8fa6a9d089ca6c07ff4453d86c65c145d0a300bb073b9b/rich-14.1.0.tar.gz"
    sha256 "e497a48b844b0320d45007cdebfeaeed8db2a4f4bcf49f15e455cfc4af11eaa8"
  end

  resource "securesystemslib" do
    url "https://files.pythonhosted.org/packages/f2/d4/6f0ce9503269a94c307a51827c5c9fe0aa8f6b6aaaf9af36c9c611ba65f6/securesystemslib-1.3.0.tar.gz"
    sha256 "5b53e5989289d97fa42ed7fde1b4bad80985f15dba8c774c043b395a90c908e5"
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

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "typing-inspection" do
    url "https://files.pythonhosted.org/packages/f8/b1/0c11f5058406b3af7609f121aaa6b609744687f1d158b3c3a5bf4cc94238/typing_inspection-0.4.1.tar.gz"
    sha256 "6ae134cc0203c33377d43188d4064e9b357dba58cff3185f22924610e70a9d28"
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

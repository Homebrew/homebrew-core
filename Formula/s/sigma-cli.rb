class SigmaCli < Formula
  include Language::Python::Virtualenv

  desc "CLI based on pySigma"
  homepage "https://github.com/SigmaHQ/sigma-cli"
  url "https://files.pythonhosted.org/packages/5a/69/8c7583ddca7b3bb369a497526c56131b674eeae6cf6e4ccdb2f16922188c/sigma_cli-1.0.6.tar.gz"
  sha256 "5cd4471fcda44ea8e5671c81cc86bc685227107df57e128b75e125ee3d6d4123"
  license "LGPL-2.1-or-later"
  revision 2
  head "https://github.com/SigmaHQ/sigma-cli.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "c52a3d701cb7954648073ab399acf23aa9ba92001c1616b78509f58a904c2aed"
    sha256 cellar: :any,                 arm64_sonoma:  "54ff4d366f2bd84868094772ea97010b70eab5ff747025b713e81904fa793983"
    sha256 cellar: :any,                 arm64_ventura: "7249cf7861b6cb71bc72f301d9a5d6063b9101253f95787b9221205c50072d8c"
    sha256 cellar: :any,                 sonoma:        "cccba010339924acd2086d9067db8c9ba572cdd04be8fa0df1c12d60ca72d3ae"
    sha256 cellar: :any,                 ventura:       "bc4db80a1e8db098cc30cf8bd4c785f6eef7ed645c209824d84976560b0558ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9464d4ecedc600741583518048cd27c0126e1bef18130136527698bb795e6a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d24671a6f4c327b4b170eb1e4a47c5d97cddaac7848370e03d87e447821b80b"
  end

  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.13"

  conflicts_with "open-simh", because: "both install `sigma` binaries"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e4/33/89c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12d/charset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/60/6c/8ca2efa64cf75a977a0d7fac081354553ebe483345c734fb6b6515d96bbc/click-8.2.1.tar.gz"
    sha256 "27c491cc05d968d271d5a1db13e3b5a184636d9d930f148c50b038f0d0646202"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d0/63/68dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106da/packaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "prettytable" do
    url "https://files.pythonhosted.org/packages/99/b1/85e18ac92afd08c533603e3393977b6bc1443043115a47bb094f3b98f94f/prettytable-3.16.0.tar.gz"
    sha256 "3c64b31719d961bf69c9a7e03d0c1e477320906a98da63952bc6698d6164ff57"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/bb/22/f1129e69d94ffff626bdb5c835506b3a5b4f3d070f17ea295e12c2c6f60f/pyparsing-3.2.3.tar.gz"
    sha256 "b9c13f1ab8b3b542f72e28f634bad4de758ab3ce4546e4301970ad6fa77c38be"
  end

  resource "pysigma" do
    url "https://files.pythonhosted.org/packages/a7/b8/8eff31a60505197d2e0b99eded0e5e75fa8197b5b4f62176a0b76d76a651/pysigma-0.11.23.tar.gz"
    sha256 "9556852055ba28c8df4c8e283f58136f722c4a18d31c7ac3ede6dbcfdd14871a"
  end

  resource "pysigma-backend-sqlite" do
    url "https://files.pythonhosted.org/packages/72/63/e618d84f770f982afa5f8e99a93c99c48bd87992d1ba4cc961aab6ba15e9/pysigma_backend_sqlite-0.2.0.tar.gz"
    sha256 "0ff1bbb0165477e938e2951808ba348bd29803fd3fae5c4cbcd117532e622217"

    # poetry 2.0 build patch, upstream pr ref, https://github.com/SigmaHQ/pySigma-backend-sqlite/pull/6
    patch do
      url "https://github.com/SigmaHQ/pySigma-backend-sqlite/commit/865350ce1a398acd7182f6f8429c3048db54ef1d.patch?full_index=1"
      sha256 "aff54090de9eecf5e5c0d69abd3be294ca86eba6b2e58d0c574528bd6058bfc4"
    end
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e1/0a/929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8/requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  def install
    # The source doesn't have a valid SOURCE_DATE_EPOCH, so here we set default.
    ENV["SOURCE_DATE_EPOCH"] = "1451574000"

    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"sigma", shells: [:bash, :fish, :zsh], shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sigma version")

    output = shell_output("#{bin}/sigma plugin list")
    assert_match "SQLite and Zircolite backend", output

    # Only show compatible plugins
    output = shell_output("#{bin}/sigma plugin list --compatible")
    refute_match "IBM QRadar backend", output
  end
end

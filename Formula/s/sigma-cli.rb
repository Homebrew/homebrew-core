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
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "ccde194db00a05ca3a6b270c45038315ec21f53d1d4915ba540118adc7712b40"
    sha256 cellar: :any,                 arm64_sequoia: "77e8ccc39d5b42a86d80a9d68020dfc1a1b51ce69167a4f3c96e06b681887cfb"
    sha256 cellar: :any,                 arm64_sonoma:  "b6fe6a8243c8ae4a1d942fa5210266f490226f870ce8a7b741fc0ccb12a752ff"
    sha256 cellar: :any,                 sonoma:        "37b40a2294883b7879c63a29b7d4632186daed7f0b5bbbe9543bf400e393374e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f6d367b7e528e29b9ba1243daea9e68fa066660ffebac8d7f5116e47ddaa399"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1726d31adcbfdf2759f6a52e550c74513b8d65ae9a5d1d8eafcc4fa12071aba0"
  end

  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.14"

  conflicts_with "open-simh", because: "both install `sigma` binaries"

  pypi_packages exclude_packages: "certifi",
                extra_packages:   "pysigma-backend-sqlite"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/83/2d/5fd176ceb9b2fc619e63405525573493ca23441330fcdaee6bef9460e924/charset_normalizer-3.4.3.tar.gz"
    sha256 "6fce4b8500244f6fcb71465d4a4930d132ba9ab8e71a7859e6a5d59851068d14"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/46/61/de6cd827efad202d7057d93e0fed9294b96952e188f7384832791c7b2254/click-8.3.0.tar.gz"
    sha256 "e7b8232224eba16f4ebe410c25ced9f7875cb5f3263ffc93cc3e8da705e229c4"
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
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
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
    url "https://files.pythonhosted.org/packages/f2/a5/181488fc2b9d093e3972d2a472855aae8a03f000592dbfce716a512b3359/pyparsing-3.2.5.tar.gz"
    sha256 "2df8d5b7b2802ef88e8d016a2eb9c7aeaa923529cd251ed0fe4608275d4105b6"
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
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/24/30/6b0809f4510673dc723187aeaf24c7f5459922d01e2f794277a3dfb90345/wcwidth-0.2.14.tar.gz"
    sha256 "4d478375d31bc5395a3c55c40ccdf3354688364cd61c4f6adacaa9215d0b3605"
  end

  def install
    # hatch does not support a SOURCE_DATE_EPOCH before 1980.
    # Remove after https://github.com/pypa/hatch/pull/1999 is released.
    ENV["SOURCE_DATE_EPOCH"] = "1451574000"

    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"sigma", shell_parameter_format: :click)
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

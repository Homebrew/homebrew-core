class Tartufo < Formula
  include Language::Python::Virtualenv

  desc "Searches through git repositories for high entropy strings and secrets"
  homepage "https://tartufo.readthedocs.io/en/stable/"
  # TODO: Switch to PyPI when upstream fixes workflow for 2FA
  url "https://github.com/godaddy/tartufo/archive/refs/tags/v6.0.0.tar.gz"
  sha256 "ba84bb6192a3647a0dd2f8b4c08c7aff46e8d5bc742e13ee1714477ae8ad7787"
  license "GPL-2.0-only"
  revision 3
  head "https://github.com/godaddy/tartufo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2e9fd88e61ace7e5c07098c471c4a97de3f2a02bec564ed4f5344773dd171eb7"
  end

  depends_on "pygit2" => :no_linkage
  depends_on "python@3.14"

  uses_from_macos "libffi"

  pypi_packages exclude_packages: "pygit2"

  resource "cached-property" do
    url "https://files.pythonhosted.org/packages/61/2c/d21c1c23c2895c091fa7a91a54b6872098fea913526932d21902088a7c41/cached-property-1.5.2.tar.gz"
    sha256 "9fa5755838eecbb2d234c3aa390bd80fbd3ac6b6869109bfc1b499f7bd89a130"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/76/d4/81420972a676e8ffea40450d8c8c92943e7218a78fe9b64359836cc9876b/click-8.4.2.tar.gz"
    sha256 "9a6cea6e60b17ebe0a44c5cc636d94f09bd66142c1cd7d8b4cd731c4917a15f6"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/72/94/63b0fc47eb32792c7ba1fe1b694daec9a63620db1e313033d18140c2320a/gitdb-4.0.12.tar.gz"
    sha256 "5ef71f855d191a3326fcfbc0d5da835f26b13fbcba60c32c21091c349ffdb571"
  end

  resource "gitpython" do
    url "https://files.pythonhosted.org/packages/17/24/0e0c12cb6f7cb864779a9d2fefee9ca91838f6db402c8780c9d28a8d7ebe/gitpython-3.1.53.tar.gz"
    sha256 "06ae8d9623b0ed0d67b8adeac5c7008d0a5a404b087a9e0d0c7163bdd3a6b497"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/1f/ea/49c993d6dfdd7338c9b1000a0f36817ed7ec84577ae2e52f890d1a4ff909/smmap-5.0.3.tar.gz"
    sha256 "4d9debb8b99007ae47165abc08670bd74cb74b5227dda7f643eccc4e9eb5642c"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/cc/18/0bbf3884e9eaa38819ebe46a7bd25dcd56b67434402b66a58c4b8e552575/tomlkit-0.13.3.tar.gz"
    sha256 "430cf247ee57df2b94ee3fbe588e71d362a941ebb545dec29b53961d61add2a1"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"tartufo", shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tartufo --version")

    output = shell_output("#{bin}/tartufo scan-remote-repo https://github.com/godaddy/tartufo.git")
    assert_match "All clear. No secrets detected.", output
  end
end

class Vulture < Formula
  include Language::Python::Virtualenv

  desc "Find dead Python code"
  homepage "https://github.com/jendrikseipp/vulture"
  url "https://files.pythonhosted.org/packages/de/ff/196ca63becc5faf5586202ab6e30102322adeea538bb45549d97ed38225d/vulture-2.7.tar.gz"
  sha256 "67fb80a014ed9fdb599dd44bb96cb54311032a104106fc2e706ef7a6dad88032"
  license "MIT"
  head "https://github.com/jendrikseipp/vulture.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d11f595d691b21b227382d09adb74437e4b25d6482780ebd95aa6c8d5ba7aa5b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "071ea2709a1009764f931f818905bf72750f6cea6abd7dc59c3b3d250fccfd98"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1241f79a16b99c7d8a096b37add6615922dcfc3bd8e34fc12b5cb71a01d4d4fd"
    sha256 cellar: :any_skip_relocation, ventura:        "2d4b42b3ffdd26b65344bbe139e26d23071df5fe5681eec234955d545941960f"
    sha256 cellar: :any_skip_relocation, monterey:       "9f4837aa8117c44ba701530cb172f544578fb794334e9712466024f1b5980135"
    sha256 cellar: :any_skip_relocation, big_sur:        "711e5eace767bf5709c30a40c5eba3fa44ad6c02ea5e458a702cc5f932a8a4cb"
    sha256 cellar: :any_skip_relocation, catalina:       "e969922ac274f48e9038ae5b4a849245aeab4822f743b25d957dd93d812f9889"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a421ed113b859839b654001afa8b7a8e6ff116a4138cc0f8eb92d9e715d4c653"
  end

  depends_on "python@3.11"

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "vulture #{version}\n", shell_output("#{bin}/vulture --version")
    (testpath/"unused.py").write "class Unused: pass"
    assert_match "unused.py:1: unused class 'Unused'", shell_output("#{bin}/vulture #{testpath}/unused.py", 1)
    (testpath/"used.py").write "print(1+1)"
    assert_empty shell_output("#{bin}/vulture #{testpath}/used.py")
  end
end

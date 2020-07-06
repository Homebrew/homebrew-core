class Rbtools < Formula
  include Language::Python::Virtualenv

  desc "CLI and API for working with code and document reviews on Review Board"
  homepage "https://www.reviewboard.org/downloads/rbtools/"
  url "https://files.pythonhosted.org/packages/04/98/10d5f67470c48e000cf9c95fb748f6a302eb01c0cb006d3ec37ff2f1e7c1/RBTools-1.0.3.tar.gz"
  sha256 "ff4cea3ad7b2d1b1666b811021cf5047f1fbe9417428fb5133a40ede81e3e83c"
  license "MIT"
  head "https://github.com/reviewboard/rbtools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5a748911d650da054e85d6c78c208664b64c9c78a22c6a44ad33959317893b2c" => :catalina
    sha256 "cedc380f26e21667b91379462b7108f231c81a736650412f322c5256bb55a2cb" => :mojave
    sha256 "6aa5f77cc2368f5e442635294a6878d1e3d738a0ac27083ba3856b255c0b3ba2" => :high_sierra
  end

  depends_on "python@3.8"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/76/53/e785891dce0e2f2b9f4b4ff5bc6062a53332ed28833c7afede841f46a5db/colorama-0.4.1.tar.gz"
    sha256 "05eed71e2e327246ad6b38c540c4a3117230b19679b875190486ddd2d721422d"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/dd/bf/4138e7bfb757de47d1f4b6994648ec67a51efe58fa907c1e11e350cddfca/six-1.12.0.tar.gz"
    sha256 "d16a0141ec1a18405cd4ce8b4613101da75da0e9a7aec5bdd4fa804d0e0eba73"
  end

  resource "texttable" do
    url "https://files.pythonhosted.org/packages/04/c6/7d2514d76fefba65bfe2fa4e1082c3adea9edef5a149a3027b8f2d5ee0eb/texttable-1.6.1.tar.gz"
    sha256 "2b60a5304ccfbeac80ffae7350d7c2f5d7a24e9aab5036d0f82489746419d9b2"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/d0/0a/50a145091ce0c02db89d0342a59327c1ddeee206ef2991f09158d4e52406/tqdm-4.32.2.tar.gz"
    sha256 "25d4c0ea02a305a688e7e9c2cdc8f862f989ef2a4701ab28ee963295f5b109ab"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "git", "init"
    system "#{bin}/rbt", "setup-repo", "--server", "https://demo.reviewboard.org"
    out = shell_output("#{bin}/rbt clear-cache")
    assert_match "Cleared cache in", out
  end
end

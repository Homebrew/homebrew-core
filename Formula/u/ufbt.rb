class Ufbt < Formula
  include Language::Python::Virtualenv

  desc "Compact tool for building and debugging applications for Flipper Zero"
  homepage "https://pypi.org/project/ufbt/"
  url "https://files.pythonhosted.org/packages/59/3b/013525f91836171870c49a53db8d2f772b5d32e682c0d25d0d0481c9bb51/ufbt-0.2.6.tar.gz"
  sha256 "4f1a858858598ed2e25bbab69e2ea604bc00758c3b1e8ecf897a29866157363b"
  license "GPL-3.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "561e844026e50a7d961338d459851e9d62bca87f7449fc9404234b31a24e73d2"
  end

  depends_on "python@3.13"

  resource "mslex" do
    url "https://files.pythonhosted.org/packages/b7/ec/530f1098d88f2076038799ddfe29d9b6e4d982df938ef6288e67d18b3f68/mslex-1.2.0.tar.gz"
    sha256 "79e2abc5a129dd71cdde58a22a2039abb7fa8afcbac498b723ba6e9b9fbacc14"
  end

  resource "oslex" do
    url "https://files.pythonhosted.org/packages/5e/a9/ebd426ee0ca59fb5ba8f0039c53989f4ca475f2dd9583b5719e2fb01602c/oslex-0.1.3.tar.gz"
    sha256 "1ed4cd82c75df2a8bcb0da34400984183753933155d0c7d999fa533137685f2d"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["UFBT_HOME"] = testpath/".ufbt"
    system bin/"ufbt", "vscode_dist", "create", "APPID=test_app"
  end
end

class Ufbt < Formula
  include Language::Python::Virtualenv

  desc "Compact tool for building and debugging applications for Flipper Zero"
  homepage "https://pypi.org/project/ufbt/"
  url "https://files.pythonhosted.org/packages/59/3b/013525f91836171870c49a53db8d2f772b5d32e682c0d25d0d0481c9bb51/ufbt-0.2.6.tar.gz"
  sha256 "4f1a858858598ed2e25bbab69e2ea604bc00758c3b1e8ecf897a29866157363b"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, all: "2bd8cb39ff223bce351824caed83bc909b0b7bea6e61b7c8e91cc2c000bef32c"
  end

  depends_on "python@3.14"

  resource "mslex" do
    url "https://files.pythonhosted.org/packages/e0/97/7022667073c99a0fe028f2e34b9bf76b49a611afd21b02527fbfd92d4cd5/mslex-1.3.0.tar.gz"
    sha256 "641c887d1d3db610eee2af37a8e5abda3f70b3006cdfd2d0d29dc0d1ae28a85d"
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

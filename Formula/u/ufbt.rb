class Ufbt < Formula
  include Language::Python::Virtualenv

  desc "Compact tool for building and debugging applications for Flipper Zero"
  homepage "https://pypi.org/project/ufbt/"
  url "https://files.pythonhosted.org/packages/59/3b/013525f91836171870c49a53db8d2f772b5d32e682c0d25d0d0481c9bb51/ufbt-0.2.6.tar.gz"
  sha256 "4f1a858858598ed2e25bbab69e2ea604bc00758c3b1e8ecf897a29866157363b"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, all: "00e922d31e19d1c9aad213ca15399df739f4d450130d1247444a8cb2c4807a74"
  end

  depends_on "python@3.15"

  resource "mslex" do
    url "https://files.pythonhosted.org/packages/e0/97/7022667073c99a0fe028f2e34b9bf76b49a611afd21b02527fbfd92d4cd5/mslex-1.3.0.tar.gz"
    sha256 "641c887d1d3db610eee2af37a8e5abda3f70b3006cdfd2d0d29dc0d1ae28a85d"
  end

  resource "oslex" do
    url "https://files.pythonhosted.org/packages/24/19/b74ea9590378a35014acf72f221e84c5980aa7531d1852ef961764e7d3a6/oslex-2.0.0.tar.gz"
    sha256 "30d9f4a7201bdce3ab7d9cfc0f9ee9e18c423b2b1d1668141b0dd3594b368ffe"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["UFBT_HOME"] = testpath/".ufbt"
    system bin/"ufbt", "vscode_dist", "create", "APPID=test_app"
  end
end

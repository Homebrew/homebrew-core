class Terminalimageviewer < Formula
  desc "Display images in a terminal using block graphic characters"
  homepage "https://github.com/stefanhaustein/TerminalImageViewer"
  url "https://github.com/stefanhaustein/TerminalImageViewer/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "9a5f5c8688ef8db0e88dfcea6a1ae30da32268a7ab7972ff0de71955a75af0db"
  license "Apache-2.0"
  head "https://github.com/stefanhaustein/TerminalImageViewer.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c81b92d798635c6fdae0106ed4a1633c70985e93f80e8dee1506e53b214ce29d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f6aeba5ada7ff92bc303930dfc3fba0d89cc3d6a06a0ce12db97856e2b4dde8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1cfe13918f86cb72157a042bc009874829d4cf59ab9426ab3bdda4614421d22c"
    sha256 cellar: :any_skip_relocation, ventura:        "1743e0ace153f89e0a9e7e4fc05c17ddb0cca6f8c2c2c20aa4309ee1966cb06b"
    sha256 cellar: :any_skip_relocation, monterey:       "9197c1aa0d01e3bafaa8500ea96b56c0b7fba1f0b20d2fede4b8d30df2d10b9a"
    sha256 cellar: :any_skip_relocation, big_sur:        "dbec90a4aa92c309150e28ba05bb18ba992f4904e590c97b43dc5a8273917aa6"
    sha256 cellar: :any_skip_relocation, catalina:       "87321c04895355910aa3fdeb3ddd7ee0bb57360dc4e2ca833757c0143a730632"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3cbd1e574fbc0887390334a602a6110a98f1d6400c3cac9ccd9bac1adf28908a"
  end

  depends_on "imagemagick"
  depends_on macos: :catalina

  fails_with gcc: "5"

  def install
    cd "src/main/cpp" do
      system "make"
      bin.install "tiv"
    end
  end

  test do
    system bin/"tiv", test_fixtures("test.png")
  end
end

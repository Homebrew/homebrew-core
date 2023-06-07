class Teapot < Formula
  desc "Table editor and planner"
  homepage "https://www.syntax-k.de/projekte/teapot/"
  url "https://www.syntax-k.de/projekte/teapot/teapot-2.3.0.tar.gz"
  sha256 "580e0cb416ae3fb3df87bc6e92e43bf72929d47b65ea2b50bc09acea3bff0b65"
  license "GPL-3.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "15393bd718e2105b8d51579fa59d5248c46b37e4432f5b5dcaea63c95e0b7a7e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7cc7392844bbae930942bf7d9a5d469b817987342f4720fd36986edd751cecdd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ebe49b24ad7903b64f8cc19a560a58b5cb1e704bcf923a79275e0264607f3541"
    sha256 cellar: :any_skip_relocation, ventura:        "9e4f061c730703fa3be5a316fe958f20bef0ec15e6b2c50b607f253008fa6582"
    sha256 cellar: :any_skip_relocation, monterey:       "73763f2ac7b281df03689a81b60b1f450a95b1a5194bb99a7bd97b3a429890e8"
    sha256 cellar: :any_skip_relocation, big_sur:        "9e578ba5acd3f0ed9e1aa11011b6aafaa2d807d69c6849fcc0b96645b0c13ba8"
    sha256 cellar: :any_skip_relocation, catalina:       "590fcacca0a46973b2ce6dd07e30d360e600aa86950af7d3a25d5d3f12512cc4"
    sha256 cellar: :any_skip_relocation, mojave:         "29d1d772e73a64a1616dcbeb3d32e8839ec7642f809d604eef52ac7805405ba3"
    sha256 cellar: :any_skip_relocation, high_sierra:    "f918044ee7953b5cc9be50487cc86bf57b4e217990551cc67c6f0c9c41f0ac0a"
    sha256 cellar: :any_skip_relocation, sierra:         "f0dc057cdfa1aa5168898a22791ee72fd3e525fd750838e94147f8b3811c1b07"
    sha256 cellar: :any_skip_relocation, el_capitan:     "84673e8886e1f24250116d8c423383d0babbc53e1cb669ba46b45a37a2344399"
  end

  deprecate! date: "2022-05-14", because: "Upstream website has disappeared"

  depends_on "cmake" => :build

  # The upstream tarball still defines the version number as "2.2.1", even
  # though the tarball contains the directory name "teapot-2.3.0" and there are
  # significant differences between this and the 2.2.1 tarball.
  patch :DATA

  def install
    args = std_cmake_args + ["-DENABLE_HELP=OFF", ".."]
    mkdir "macbuild" do
      system "cmake", *args
      system "make", "install"
    end
    doc.install "doc/teapot.lyx"
  end
end
__END__
diff --git a/config.h b/config.h
index 2a4e34f..cdf11a1 100644
--- a/config.h
+++ b/config.h
@@ -1,7 +1,7 @@
 /* configuration values */


-#define VERSION "2.2.1"
+#define VERSION "2.3.0"

 #define HELPFILE "/usr/local/share/doc/teapot/html/index.html"

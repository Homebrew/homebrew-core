class Qjackctl < Formula
  desc "Simple Qt application to control the JACK sound server daemon"
  homepage "https://qjackctl.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/qjackctl/qjackctl/0.9.3/qjackctl-0.9.3.tar.gz"
  sha256 "e9c2ffc219863c8c3dcdb05c4870d419b1625906852294f15c62d590b331bd18"
  license "GPL-2.0-or-later"
  head "https://git.code.sf.net/p/qjackctl/code.git"

  livecheck do
    url :stable
    regex(%r{url=.*?/qjackctl[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_big_sur: "6f307d378c51e9a878afa808c8ab9a83a22d78e0daa64719d9bc9e8d8eba8d76"
    sha256 big_sur:       "a2bbdebd6049b024d735ef5495899bcfdfb7d067026694f9730f2d4df3254403"
    sha256 catalina:      "abebcbd47045dcf255752535e6d24b381333702284abbf84ac0abf0faad53132"
    sha256 mojave:        "67f7792ff4b1876d815f771609369d7a318c716a3fe13fdd8e08df166f40fc50"
  end

  depends_on "pkg-config" => :build
  depends_on "jack"
  depends_on "qt@5"

  def install
    ENV.cxx11
    system "./configure", "--disable-debug",
                          "--disable-dbus",
                          "--disable-portaudio",
                          "--disable-xunique",
                          "--prefix=#{prefix}",
                          "--with-jack=#{Formula["jack"].opt_prefix}",
                          "--with-qt=#{Formula["qt@5"].opt_prefix}"

    system "make", "install"
    prefix.install bin/"qjackctl.app"
    bin.install_symlink prefix/"qjackctl.app/Contents/MacOS/qjackctl"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/qjackctl --version 2>&1", 1)
  end
end

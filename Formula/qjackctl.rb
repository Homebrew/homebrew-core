class Qjackctl < Formula
  desc "Simple Qt application to control the JACK sound server daemon"
  homepage "https://qjackctl.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/qjackctl/qjackctl/0.9.2/qjackctl-0.9.2.tar.gz"
  sha256 "867c088ed819f61d2eb1e550d4bb8f6330d8f247ab99843a584d81825f1a5d24"
  license "GPL-2.0-or-later"
  head "https://git.code.sf.net/p/qjackctl/code.git"

  livecheck do
    url :stable
    regex(%r{url=.*?/qjackctl[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 big_sur:  "b3333344546f23d530cf7a51eaac17aa3be91173b342af77a1320a6d2f09ee9e"
    sha256 catalina: "e63ba89a11cfae5b86637cd7de64706b4de02b6d456a38436b8f6198276ccdf3"
    sha256 mojave:   "840f21c62070b620bf4b1611b6b0248c2c66f761b32c08286b0a97c3fa64ab32"
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

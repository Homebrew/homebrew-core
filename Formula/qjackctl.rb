class Qjackctl < Formula
  desc "Simple Qt application to control the JACK sound server daemon"
  homepage "https://qjackctl.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/qjackctl/qjackctl/0.6.3/qjackctl-0.6.3.tar.gz"
  sha256 "9db46376cfacb2e2ee051312245f5f7c383c9f5a958c0e3d661b9bd2a9246b7d"
  license "GPL-2.0"
  head "https://git.code.sf.net/p/qjackctl/code.git"

  livecheck do
    url :stable
    regex(%r{url=.*?/qjackctl[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 "8e30b2f2b2587c3177287a8a47f785862d0f6201e92f8cfc90ea16e17e2e405c" => :catalina
    sha256 "902219e2f8d6e223a2375eeeb92470e0fefce0acb4d960b250a5c2ac5e5cef97" => :mojave
    sha256 "c77bf5a0063a9c265b1c9c343a47e399f000a49acc496ace4c081398fa6e16cb" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "jack"
  depends_on "qt"

  def install
    ENV.cxx11
    system "./configure", "--disable-debug",
                          "--disable-dbus",
                          "--disable-portaudio",
                          "--disable-xunique",
                          "--prefix=#{prefix}",
                          "--with-jack=#{Formula["jack"].opt_prefix}",
                          "--with-qt=#{Formula["qt"].opt_prefix}"

    system "make", "install"
    prefix.install bin/"qjackctl.app"
    bin.install_symlink prefix/"qjackctl.app/Contents/MacOS/qjackctl"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/qjackctl --version 2>&1", 1)
  end
end

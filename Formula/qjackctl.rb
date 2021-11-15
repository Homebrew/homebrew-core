class Qjackctl < Formula
  desc "Simple Qt application to control the JACK sound server daemon"
  homepage "https://qjackctl.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/qjackctl/qjackctl/0.9.4/qjackctl-0.9.4.tar.gz"
  sha256 "febf7019f775a07d167f255756c27e55832656ccf69d1c744b4ce563e478d9a0"
  license "GPL-2.0-or-later"
  head "https://git.code.sf.net/p/qjackctl/code.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{url=.*?/qjackctl[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_monterey: "b351350ffcca1515d3d77b7eea70504f98d0eec29d4ef29599ef9cbfa7aea1d1"
    sha256 arm64_big_sur:  "186c081fcdb6bdd0fd58175c8aea96f164bfaa465da97136cd2f8ab9ee1b2227"
    sha256 big_sur:        "4ed17595db8a68f83e15117bd056b3e67fc45b0f35f22dcd5bbc25c321ad407b"
    sha256 catalina:       "616930b85129a5cc17239da15363b37c6037731858a17c493fa3dbef737f1373"
    sha256 mojave:         "c1b716c18fb6fa8c3fd6b4745aa86692666625ae4ab45fd2bb9fa59e22b7eeaf"
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

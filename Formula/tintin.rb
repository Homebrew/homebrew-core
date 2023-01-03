class Tintin < Formula
  desc "MUD client"
  homepage "https://tintin.mudhalla.net/"
  url "https://github.com/scandum/tintin/releases/download/2.02.30/tintin-2.02.30.tar.gz"
  sha256 "ce25add4554534e92f9809c575ccf17d4006c8916f5ff2bce2c400d928c16cd4"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "04ba27386e024df2ca2d7905d0afb149613b62f46920f2c824cc6e80a9ad9335"
    sha256 cellar: :any,                 arm64_monterey: "48a14b8488fdae849fcf847c92cd2fdea37e814284f3af7c3b199d4d10496cb9"
    sha256 cellar: :any,                 arm64_big_sur:  "9fb7ab0ff117f7e06a170a47d7ae4b6fc7c7428029a7e35af5b44129f806fd9f"
    sha256 cellar: :any,                 ventura:        "9e720f08fc7d8c789e5ff4633c59e5e89d6379fdac3b70927694fb01c65bbeaa"
    sha256 cellar: :any,                 monterey:       "2cedaf1105289a8325718b608d49bbb096c5138e7958c1774107a7a4f3a4fde8"
    sha256 cellar: :any,                 big_sur:        "2de951851183ecf07d93fc53061a4a0002a7fa5453fd75d87f1dcdf6c7d64b8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc8f655883b796ec746d619c064554d70f16c4625cea89695061c488412a1815"
  end

  depends_on "gnutls"
  depends_on "pcre"

  def install
    # find Homebrew's libpcre
    ENV.append "LDFLAGS", "-L#{HOMEBREW_PREFIX}/lib"

    cd "src" do
      system "./configure", "--prefix=#{prefix}"
      system "make", "CFLAGS=#{ENV.cflags}",
                     "INCS=#{ENV.cppflags}",
                     "LDFLAGS=#{ENV.ldflags}",
                     "install"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tt++ -V", 1)
  end
end

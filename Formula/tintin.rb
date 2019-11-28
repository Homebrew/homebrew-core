class Tintin < Formula
  desc "MUD client"
  homepage "https://tintin.sourceforge.io/"
  url "https://downloads.sourceforge.net/tintin/tintin-2.01.92.tar.gz"
  sha256 "3386d49810f2dbc162f890f26bb81e3807af34753d7a4ead64cc40e845cba845"

  bottle do
    cellar :any
    sha256 "0cfa11646ff885e58bb0f87047f4ec0edaa7836c2f5f333bc035201a7f0dbd30" => :catalina
    sha256 "d9be7933ef0d952ffa2ec9487871ed5e63567e36dde53387ecea37c672f3d70a" => :mojave
    sha256 "6ecdefbc34ed97a8eecab4eba39837864a6fb764adedf16f4ecabb317e6f12e4" => :high_sierra
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
    shell_output("#{bin}/tt++ -e \"#nop; #info system; #end;\"")
  end
end

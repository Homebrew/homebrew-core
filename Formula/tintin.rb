class Tintin < Formula
  desc "MUD client"
  homepage "https://tintin.sourceforge.io/"
  url "https://downloads.sourceforge.net/tintin/tintin-2.01.92.tar.gz"
  sha256 "3386d49810f2dbc162f890f26bb81e3807af34753d7a4ead64cc40e845cba845"

  bottle do
    cellar :any
    sha256 "788bde2c6f1b9af071b9fd34408d2604772d94f8ac1682103a448dae8f84cacf" => :catalina
    sha256 "d8b6468b14df8cd486546f27702478c574d3f25fbbdd8f2fe60debbb49bb5ccb" => :mojave
    sha256 "8ee71f28fee2146074728f5899b1e2c8f78e57404f1a19cffd236d92467ed44f" => :high_sierra
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

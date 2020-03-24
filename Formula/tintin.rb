class Tintin < Formula
  desc "MUD client"
  homepage "https://tintin.mudhalla.net/"
  url "https://github.com/scandum/tintin/releases/download/2.02.02/tintin-2.02.02.tar.gz"
  sha256 "c5d8b6c930ec0beb9f45de434e079dddb17b48f8a3acff08acbc9d1bd15dd487"

  bottle do
    cellar :any
    sha256 "4f08321d1f4ad35d1ad4eb635527ecd48321eea3c0346ac639d702ed917f63fe" => :catalina
    sha256 "884e881629347145c24b34887ead7ecb59d5f82c80d35f5003d3aa8507ed47b7" => :mojave
    sha256 "07cfe88a3b77d6788ed0afa72ac65dbc3b86db90eac39e6ceaabc1d1b758bb9f" => :high_sierra
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

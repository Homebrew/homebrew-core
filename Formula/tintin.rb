class Tintin < Formula
  desc "MUD client"
  homepage "https://tintin.mudhalla.net/"
  url "https://github.com/scandum/tintin/releases/download/2.02.01/tintin-2.02.01.tar.gz"
  sha256 "decc933d18f91e0d890e13325d8e9e60eff4238bdf3f431a647dac0c9ad15295"

  bottle do
    cellar :any
    sha256 "4f08321d1f4ad35d1ad4eb635527ecd48321eea3c0346ac639d702ed917f63fe" => :catalina
    sha256 "884e881629347145c24b34887ead7ecb59d5f82c80d35f5003d3aa8507ed47b7" => :mojave
    sha256 "07cfe88a3b77d6788ed0afa72ac65dbc3b86db90eac39e6ceaabc1d1b758bb9f" => :high_sierra
  end

  depends_on "gnutls"
  depends_on "pcre"

  # fix for https://github.com/scandum/tintin/pull/7, included in next version
  patch do
    url "https://github.com/scandum/tintin/commit/259d33ae40c601dc2fd2ce23c10928b08a9b1c15.diff?full_index=1"
    sha256 "85b9f6f263b16836cd1619d22f039aa37da4e4661c167d5aff020475868d5354"
  end

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

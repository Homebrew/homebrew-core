class Tintin < Formula
  desc "MUD client"
  homepage "https://tintin.mudhalla.net/"
  url "https://github.com/scandum/tintin/releases/download/2.02.01/tintin-2.02.01.tar.gz"
  sha256 "decc933d18f91e0d890e13325d8e9e60eff4238bdf3f431a647dac0c9ad15295"

  bottle do
    cellar :any
    sha256 "3da12a97145f035ed9ae5bf0f038800ff4a4f7aba014546e0e54960f64d414d8" => :catalina
    sha256 "ec78955fa2d9637332d29399c9b790e78567854b97847af5f6bc1fbb3a0ecaee" => :mojave
    sha256 "d907ef0afbbd3bc01792d8806968861e13b712b2228c5e505ba1996c075478e1" => :high_sierra
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

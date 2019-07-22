class Tintin < Formula
  desc "MUD client"
  homepage "https://tintin.sourceforge.io/"
  url "https://downloads.sourceforge.net/tintin/tintin-2.01.8.tar.gz"
  sha256 "5af851ca3b143ab1f5144ded44453d64fc8abb4baac5bc1e7195a013bd40cf14"

  bottle do
    cellar :any
    sha256 "0095d467450f7e04547555ce696ab3c1237957522b5ad71abe344a8ebfbcde10" => :mojave
    sha256 "ab8ce7088ab4406f546b2875b47ba06ede4cdbfc3d83e698081343b3fcaa8ff8" => :high_sierra
    sha256 "c3c5c1bdc641d73852bbe723f6c6e441c4dc01ee4aaa84bb3bd584f0825ce9e4" => :sierra
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
    require "pty"
    (testpath/"input").write("#end {bye}\n")
    PTY.spawn(bin/"tt++", "-G", "input") do |r, _w, _pid|
      assert_match "Goodbye", r.read
    end
  end
end

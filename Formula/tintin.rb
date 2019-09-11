class Tintin < Formula
  desc "MUD client"
  homepage "https://tintin.sourceforge.io/"
  url "https://downloads.sourceforge.net/tintin/tintin-2.01.90.tar.gz"
  sha256 "6b3eef2a993250d7094c5fcd4aa6ea3e2356228b006c70062f5757577c86936c"

  bottle do
    cellar :any
    sha256 "f149950448a3c8fd4af7af4cd741ec501688da1ada83f0d461f853997fd1542b" => :mojave
    sha256 "5d34258b43da14466fa7d4e901295b30d805b84c487294d9dafeb5faf61000c7" => :high_sierra
    sha256 "e3a066af9d699b30ad7e084c2403bd97df8116560fcbc33002214f7d7ebd47f4" => :sierra
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

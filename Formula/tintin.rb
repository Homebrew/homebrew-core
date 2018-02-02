class Tintin < Formula
  desc "MUD client"
  homepage "https://tintin.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/tintin/TinTin%2B%2B%20Source%20Code/2.01.4/tintin-2.01.4.tar.gz"
  sha256 "dd22afbff45a93ec399065bae385489131af7e1b6ae8abb28f80d6a03b82ebbc"
  revision 1

  bottle do
    cellar :any
    sha256 "8ad66191775045c0d6252bc4e2fa8c2d44e0290087e9a4d8627c125da19dd61c" => :high_sierra
    sha256 "4940d4f93f2606e9cd14e044e57d557c6b5bba2f7853432a101e868e048e4801" => :sierra
    sha256 "42985a4b7b44e3036348ce810aa6301adac1564bbb5caac55fb44e14e10a9e25" => :el_capitan
  end

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

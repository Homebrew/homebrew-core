class Tintin < Formula
  desc "MUD client"
  homepage "https://tintin.sourceforge.io/"
  url "https://downloads.sourceforge.net/tintin/tintin-2.01.91.tar.gz"
  sha256 "3596a6d540d58162dc60c318c520cb94ee52fb438b5db8a2fa2513c47fbe6359"

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
    require "pty"
    (testpath/"input").write("#end {bye}\n")
    PTY.spawn(bin/"tt++", "-G", "input") do |r, _w, _pid|
      assert_match "Goodbye", r.read
    end
  end
end

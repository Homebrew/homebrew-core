class Weighttp < Formula
  desc "Webserver benchmarking tool that supports multithreading"
  homepage "https://redmine.lighttpd.net/projects/weighttp/wiki"
  url "https://github.com/lighttpd/weighttp/archive/weighttp-0.4.tar.gz"
  sha256 "b4954f2a1eca118260ffd503a8e3504dd32942e2e61d0fa18ccb6b8166594447"
  head "https://git.lighttpd.net/weighttp.git"

  bottle do
    cellar :any
    sha256 "b76ee9060b8cb86897af45c620b1f1fb3d757955a2a2f8e4c55ef6a153bfc547" => :catalina
    sha256 "2ab4f5e31f9411d55c4a4653f78bb381b70f53f49d07efaf6e99b5a86281b62a" => :mojave
    sha256 "4225f653fe64067e3330c33202a15ad65a6b194ce23619ae045cbe50528a9b02" => :high_sierra
    sha256 "242f14d7a7fb477e4722a3818a98ad25ffedd5d2c80e7c97d67c80fe2a20366c" => :sierra
    sha256 "e96be0135f552ddde0547ca914c2bc6635dcc59ce4bdeb803ab9412100d8d15b" => :el_capitan
    sha256 "e83c9f99b524b57ba31571dc673ab6d2d2a5e38a5374ce45130f11a51c063662" => :yosemite
    sha256 "914e5fbf3f6c4fd42c532fa32a741c0558b7b16a71d773722c92c64f0b42a2f3" => :mavericks
  end

  depends_on "libev"

  def install
    system "./waf", "configure"
    system "./waf", "build"
    bin.install "build/default/weighttp"
  end

  test do
    # Stick with HTTP to avoid 'error: no ssl support yet'
    system "#{bin}/weighttp", "-n", "1", "http://redmine.lighttpd.net/projects/weighttp/wiki"
  end
end

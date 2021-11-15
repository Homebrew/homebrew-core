class Weighttp < Formula
  desc "Webserver benchmarking tool that supports multithreading"
  homepage "https://redmine.lighttpd.net/projects/weighttp/wiki"
  url "https://github.com/lighttpd/weighttp/archive/weighttp-0.4.tar.gz"
  sha256 "b4954f2a1eca118260ffd503a8e3504dd32942e2e61d0fa18ccb6b8166594447"
  license "MIT"
  head "https://git.lighttpd.net/lighttpd/weighttp.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "64057edc2b2ff52e19975c6fadcc94bb456b4a37ad0a3e7f94b93b7477cdc867"
    sha256 cellar: :any, arm64_big_sur:  "61bd26ebdcd743d1078d4bd2138f55bcd943900c85acf567ccfda9fe4fc89379"
    sha256 cellar: :any, monterey:       "6c94e449d1376949e49017b614bd578d297f64b59738e4a0616667d6f2f8892d"
    sha256 cellar: :any, big_sur:        "73c147309603c830719feac16847dc9ec2f09d27dc3a3f702760efe1eaaf8405"
    sha256 cellar: :any, catalina:       "b76ee9060b8cb86897af45c620b1f1fb3d757955a2a2f8e4c55ef6a153bfc547"
    sha256 cellar: :any, mojave:         "2ab4f5e31f9411d55c4a4653f78bb381b70f53f49d07efaf6e99b5a86281b62a"
    sha256 cellar: :any, high_sierra:    "4225f653fe64067e3330c33202a15ad65a6b194ce23619ae045cbe50528a9b02"
    sha256 cellar: :any, sierra:         "242f14d7a7fb477e4722a3818a98ad25ffedd5d2c80e7c97d67c80fe2a20366c"
    sha256 cellar: :any, el_capitan:     "e96be0135f552ddde0547ca914c2bc6635dcc59ce4bdeb803ab9412100d8d15b"
    sha256 cellar: :any, yosemite:       "e83c9f99b524b57ba31571dc673ab6d2d2a5e38a5374ce45130f11a51c063662"
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

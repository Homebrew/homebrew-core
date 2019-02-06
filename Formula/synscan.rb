class Synscan < Formula
  desc "Asynchronous half-open TCP portscanner"
  homepage "http://www.digit-labs.org/files/tools/synscan/"
  url "http://www.digit-labs.org/files/tools/synscan/releases/synscan-5.02.tar.gz"
  sha256 "c4e6bbcc6a7a9f1ea66f6d3540e605a79e38080530886a50186eaa848c26591e"

  bottle do
    cellar :any_skip_relocation
    sha256 "3e798cc92043613a56d40f9d306081d23b05b878cbc9bc1ac532717a48fd802d" => :high_sierra
    sha256 "98648d8ae9cce116cd800d7773ca84e44af92d37059bc62b02b548f3e5b8cbe8" => :sierra
    sha256 "d9d3cfbe1016ff7d314cf9db8b7fa796e3d3a43e78b2552e84b224e53f73f541" => :el_capitan
    sha256 "3298295fda8028da39ddbc6c3f2d26b42de9dd4f6e3a46a4e19bb871fa545035" => :yosemite
    sha256 "4cacc06fdeda9a24bb681cb90c52c4692d5bf3993f18db496c5de19ab9d46dac" => :mavericks
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "macos"
    system "make", "install"
  end

  test do
    system "#{bin}/synscan", "-V"
  end
end

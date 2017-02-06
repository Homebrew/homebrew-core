class Rawgl < Formula
  desc "Rewritten engine for Another World"
  homepage "http://cyxdown.free.fr/rawgl/"
  url "https://github.com/cyxx/rawgl/archive/rawgl-0.2.1.tar.gz"
  sha256 "da00d4abbc266e94c3755c2fd214953c48698826011b1d4afbebb99396240073"
  head "https://github.com/cyxx/rawgl.git"

  bottle do
    cellar :any
    sha256 "f3b4affdbc9313bdb206923ee1d12e509a9acf539d25818832270cbc1c4c16a8" => :sierra
    sha256 "ed075b6796ac69e2912ee05404672f70e611276a9d884f878e8285d7a14b6214" => :yosemite
  end

  depends_on "sdl2"
  depends_on "sdl2_mixer"

  def install
    system "make"
    bin.install "rawgl"
  end

  test do
    system bin/"rawgl", "--help"
  end
end

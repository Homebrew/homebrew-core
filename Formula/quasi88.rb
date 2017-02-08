class Quasi88 < Formula
  desc "PC-8801 emulator"
  homepage "http://www.eonet.ne.jp/~showtime/quasi88/"
  url "http://www.eonet.ne.jp/~showtime/quasi88/release/quasi88-0.6.4.tgz"
  sha256 "2c4329f9f77e02a1e1f23c941be07fbe6e4a32353b5d012531f53b06996881ff"

  bottle do
    cellar :any
    sha256 "79c3574f94b42d4c9a207ae299b3f2924e2dcf17dd4c380c0fc49eab1799f8e8" => :yosemite
    sha256 "c120675872615f7594e7e255e2072debbdb92c1a467700bfdb762bfc6ead0cd7" => :mavericks
    sha256 "3215994fc8ac1255c988dbd496c9880108da0bda4aec5fda52132c7c5c874454" => :mountain_lion
  end

  depends_on "sdl"

  def install
    args = %W[
      X11_VERSION=
      SDL_VERSION=1
      ARCH=macosx
      SOUND_SDL=1
      LD=#{ENV.cxx}
      CXX=#{ENV.cxx}
      CXXLIBS=
    ]
    system "make", *args
    bin.install "quasi88.sdl" => "quasi88"
  end

  def caveats; <<-EOS.undent
    You will need to place ROM and disk files.
    Default arguments for the directories are:
      -romdir ~/quasi88/rom/
      -diskdir ~/quasi88/disk/
      -tapedir ~/quasi88/tape/
    EOS
  end

  test do
    system "#{bin}/quasi88", "-help"
  end
end

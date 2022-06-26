class Quasi88 < Formula
  desc "PC-8801 emulator"
  homepage "https://www.eonet.ne.jp/~showtime/quasi88/"
  url "https://www.eonet.ne.jp/~showtime/quasi88/release/quasi88-0.6.4.tgz"
  sha256 "2c4329f9f77e02a1e1f23c941be07fbe6e4a32353b5d012531f53b06996881ff"

  livecheck do
    url "https://www.eonet.ne.jp/~showtime/quasi88/download.html"
    regex(/href=.*?quasi88[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "86fa89cfefe5c7cc7359dc6a0c4dad83c17810a660c19f165d160574103f0144"
    sha256 cellar: :any,                 arm64_big_sur:  "d62e6a88ff70815e139f210668f4e8e433ba5c00124f1ec1464c71d29afd6fb0"
    sha256 cellar: :any,                 monterey:       "de876cce41def50514c8240deb59104ae3c7dff82ad59ca164606b535592b414"
    sha256 cellar: :any,                 big_sur:        "0666b5a2b84dede66965c0085d397c05bbd44f09338076c7860baa3790eb84ef"
    sha256 cellar: :any,                 catalina:       "2a1d1f01c210c06e49f3091dcebb2a30e62e14596e23bc43f349e151e3771d09"
    sha256 cellar: :any,                 mojave:         "8b16ac77e4b8c6481fb7f518d5f7f446ff3b8b39465fa99d7bcbb8b28a3c745f"
    sha256 cellar: :any,                 high_sierra:    "8199a69a8ecad4247752091f3eeaf5181eaa1dd0e4b2670059e21df807c646c6"
    sha256 cellar: :any,                 sierra:         "d9ff4c5657c4179371d60317e0455cbadd59d45d81d0cc71d62d14d681619e95"
    sha256 cellar: :any,                 el_capitan:     "4bef6f92d4fcdf3547e0e7b9d699f392de0ff4764bbed0d8b23ea37e22e33f78"
    sha256 cellar: :any,                 yosemite:       "f9b4ef36396de67507df8148ad22ecca3940505c40468656df03ac685930b2d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96d4f4f49723f1a6309bfa403c2cee367425301794c7da4cc7ffb51f3d802927"
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

  def caveats
    <<~EOS
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

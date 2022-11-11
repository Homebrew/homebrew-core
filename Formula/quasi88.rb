class Quasi88 < Formula
  desc "PC-8801 emulator"
  homepage "https://www.eonet.ne.jp/~showtime/quasi88/"
  url "https://www.eonet.ne.jp/~showtime/quasi88/release/quasi88-0.6.4.tgz"
  sha256 "2c4329f9f77e02a1e1f23c941be07fbe6e4a32353b5d012531f53b06996881ff"
  revision 1

  livecheck do
    url "https://www.eonet.ne.jp/~showtime/quasi88/download.html"
    regex(/href=.*?quasi88[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7b4c72ce4204ac7a10b58982ba65f7bb900f3b6bc2a71533efdd4eb8394b38e1"
    sha256 cellar: :any,                 arm64_monterey: "467c760fbe3ff26108e82a47876e626bd1e9ecbfce352c4c2d2bba4d9de9d2f9"
    sha256 cellar: :any,                 arm64_big_sur:  "c0d20d39a966111e0a9f48ea3ceb420f8de9f163d31ee5a2dbc325078e014420"
    sha256 cellar: :any,                 monterey:       "67e5b32ec92bceee098d501e77746e834f936238121840f373bcac6e1d6106ef"
    sha256 cellar: :any,                 big_sur:        "134a3b6d943790bdec6634337ec3e64c9e5715c479e1f7abb4aa4aefa2c709ab"
    sha256 cellar: :any,                 catalina:       "8a074931492249bebc0b573e1974d255adef1bf904be9ff65cc7824abc43ee07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1bab4b61c3d6420c5342a7ccc376a4d79c3238af2955fe1bb079546a29197937"
  end

  depends_on "sdl12-compat"

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

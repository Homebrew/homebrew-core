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
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "7b4c72ce4204ac7a10b58982ba65f7bb900f3b6bc2a71533efdd4eb8394b38e1"
    sha256 cellar: :any,                 arm64_monterey: "5a13523bdec455846c2a50a069305794522261565d040aac6304b2b07af649e9"
    sha256 cellar: :any,                 arm64_big_sur:  "6a128b745d94138d3fe571518ce9755c0bfa34324e229da743007e6d5961aab1"
    sha256 cellar: :any,                 ventura:        "c70a45dd3e4f7f7aed3e14cefd80319e7f1dc8644dab7597df4cdddf9191011e"
    sha256 cellar: :any,                 monterey:       "5af9ca3ad12c1bfa8d761fc1ff30d36099dd032fdd47fc2e85f89722a21de6dd"
    sha256 cellar: :any,                 big_sur:        "3a46e754acb469e4619f3cedeb402ebe45b69a096c65688697e3144aac61b413"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "278f6e32cae48b0acd18865f8793d442b5e9d5aa3a201a6d3bf179c27d39a46e"
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

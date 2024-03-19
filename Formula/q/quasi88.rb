class Quasi88 < Formula
  desc "PC-8801 emulator"
  homepage "https://www.eonet.ne.jp/~showtime/quasi88/"
  url "https://www.eonet.ne.jp/~showtime/quasi88/release/quasi88-0.7.0.tgz"
  sha256 "62bc2aa09dd19ec1d15386d96bd71148c2cdf2a0bd012529643a568a77faa714"

  livecheck do
    url "https://www.eonet.ne.jp/~showtime/quasi88/download.html"
    regex(/href=.*?quasi88[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fd5024b5cd310b12254e64c0e4b31ce1bdbf788a434a0632b62ff52f912245af"
    sha256 cellar: :any,                 arm64_ventura:  "1a7c8d32d6d7b0f0c409b9dffbdad9fde33957cd20c39f60dbc41c9319c0624b"
    sha256 cellar: :any,                 arm64_monterey: "e96d666621124f3633778e28ec26b98bde39f7510ed3e7e61cf3692ffe5d205d"
    sha256 cellar: :any,                 sonoma:         "042695a723221c23cdbacb5eec6b2b41e9180b38f47a66b88f9f75b4a03e8d9f"
    sha256 cellar: :any,                 ventura:        "a7b82ee65ce372cadad0ef2be7dd8f9dc7e87947260204640323c5b8bbe55c72"
    sha256 cellar: :any,                 monterey:       "dfdd7a24162a85fc484fc629863a52c16fd57ae3e81c76900da6c39f2bc1c081"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bce3d0326c16726bf494c20359c43e9cc226e3842ab367c9958af7eb5423a927"
  end

  depends_on "sdl12-compat"

  def install
    args = %W[
      X11_VERSION=
      SDL_VERSION=1
      ARCH=macosx
      SOUND_SDL=1
      CC=#{ENV.cc}
      CXX=#{ENV.cxx}
      LD=#{ENV.cxx}
      CXXLIBS=
    ]
    system "make", *args
    bin.install "quasi88"
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

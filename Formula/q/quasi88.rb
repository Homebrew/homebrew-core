class Quasi88 < Formula
  desc "PC-8801 emulator"
  homepage "https://www.eonet.ne.jp/~showtime/quasi88/"
  url "https://www.eonet.ne.jp/~showtime/quasi88/release/quasi88-0.7.3.zip"
  sha256 "ea8b7095917a841a5f38ce817654ee823ae1e7b0ad7c8629348d584b29667350"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.eonet.ne.jp/~showtime/quasi88/download.html"
    regex(/href=.*?quasi88[._-]v?(\d+(?:\.\d+)+)\.(?:t|zip)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "842ac1ca7dff5eab4167dbc2c254c9d10906925b88ce89358d8d60d845915acb"
    sha256 cellar: :any,                 arm64_sequoia: "20231bb2bc8ee681fd26333fec50a8d641abb9decc2a9aeedded11adce5fa046"
    sha256 cellar: :any,                 arm64_sonoma:  "c7039f1e39858b42023516c859a375d478dea926b76f274b624dfd9130a9598f"
    sha256 cellar: :any,                 arm64_ventura: "c88abc6fbf41106452bf7b3fb13c6e3626c8367382d2918d14f1041bc2e1a0b6"
    sha256 cellar: :any,                 sonoma:        "72f63671f466c20d84d1c148f2682283526d1ca2a4ea65dbcdf16d53fb476def"
    sha256 cellar: :any,                 ventura:       "d73202052e48e221a118f9f010f1c284cf83caa4c5a95c1fa7e3c393b6e4a993"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "89265c3d0c0abaed57404054d2b2ebbb65d9eee0f79c9041428ef07c019d3f13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f397f98e66812a49e708963bd8cccc62c07179828358bbebac9073fef06ecd6"
  end

  depends_on "sdl2"

  def install
    ENV.deparallelize

    args = %W[
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
    system bin/"quasi88", "-help"
  end
end

class Quasi88 < Formula
  desc "PC-8801 emulator"
  homepage "https://www.eonet.ne.jp/~showtime/quasi88/"
  url "https://www.eonet.ne.jp/~showtime/quasi88/release/quasi88-0.7.4.zip"
  sha256 "e61f110ae2adc3ee10b0e6718f58e60f796a272c25309fd0950e47e70c2844e1"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.eonet.ne.jp/~showtime/quasi88/download.html"
    regex(/href=.*?quasi88[._-]v?(\d+(?:\.\d+)+)\.(?:t|zip)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "47421a4e4fc01489f3d76dbf3e5c5a61540805e9763ac85b6cafc9ff586d85ae"
    sha256 cellar: :any,                 arm64_sequoia: "b87fc4c4e04fc3176440e8c108ad1b84f668afeb813b1e00379ca6d3da282da6"
    sha256 cellar: :any,                 arm64_sonoma:  "668cadf83d0929c5af286d639e25d31accc625c6bd7c71e0206aaa80196c5517"
    sha256 cellar: :any,                 sonoma:        "761c6ef48629e0775a1ac4a28cd01a5c8dc63d3283b299071119750f105174ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b6edab8cad958fe676cd1be78f384b60e27f83d6776e13c7763bb314b5276b58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "afb05e1ae465626203a6b28662dc320fc35720dff2d90b60f5e0491325606b88"
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

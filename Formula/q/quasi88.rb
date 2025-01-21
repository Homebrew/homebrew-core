class Quasi88 < Formula
  desc "PC-8801 emulator"
  homepage "https://www.eonet.ne.jp/~showtime/quasi88/"
  url "https://www.eonet.ne.jp/~showtime/quasi88/release/quasi88-0.7.1.tgz"
  sha256 "a9e7097e26cee6605ca3a467f6167b624dca4d11e3d99fd5c9886894b42cc05e"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.eonet.ne.jp/~showtime/quasi88/download.html"
    regex(/href=.*?quasi88[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "0eac8fdd1ee628be1f2f760272599513d3251ec2f0781d98da27fff0f5ab9917"
    sha256 cellar: :any,                 arm64_sonoma:   "5f6e0024ba90b4ea8d6db6615f01245ebb26ad6e914d5cd5720751b5b5d22399"
    sha256 cellar: :any,                 arm64_ventura:  "c5a10d08e47dfd4e46bb9248aa8ebdb6b85ceaaf26223d2190d01d28167c27d3"
    sha256 cellar: :any,                 arm64_monterey: "52ae75a5b84dab5523b36ea0b827d783a79f419a605cc059fd453ea3e74562a3"
    sha256 cellar: :any,                 sonoma:         "42b152e68b2c5b4773be2fa8e54380f3059d3864fa82e6591e6ef7c72e0fa920"
    sha256 cellar: :any,                 ventura:        "b5ccd2b099ca8067fdf747d4a97380f58a11d069ddd725e7c7174c0dceb2a88a"
    sha256 cellar: :any,                 monterey:       "58db5d7edd11c2a23a92a679d954bd1e4b0be0db0fd52d0ef2adb0425f1d5668"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5bece28e3cc116e801cbcb9da47c2e3768d0a0e15b24d05bdb2ff0f51e06496b"
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

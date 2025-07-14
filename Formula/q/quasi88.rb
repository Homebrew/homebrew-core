class Quasi88 < Formula
  desc "PC-8801 emulator"
  homepage "https://www.eonet.ne.jp/~showtime/quasi88/"
  url "https://www.eonet.ne.jp/~showtime/quasi88/release/quasi88-0.7.2.tgz"
  sha256 "e747c1b391349e1dfcea4eb615322c225e0baa642cf6e068ea9ab137b56b0355"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.eonet.ne.jp/~showtime/quasi88/download.html"
    regex(/href=.*?quasi88[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "dfde88a3d0109e08a765a3b996704f450c3014034984e9b1fd14fa1cb4f346b6"
    sha256 cellar: :any,                 arm64_sonoma:  "9ac1397a7e4769584ba3a52ff955a7ca26b19adbc3af1cef5c06a5be99e23d97"
    sha256 cellar: :any,                 arm64_ventura: "4a8476606e46b13555c3cdb716eda570d8390f639c845512e1b2f68fe0360f7d"
    sha256 cellar: :any,                 sonoma:        "8ca3a6a2ef6dacb17481ce40c3ec5594ec18de0d933d022d9a6e48dc48f28bff"
    sha256 cellar: :any,                 ventura:       "cd36cbd67168d50e7c48563abe3a7c8ce4cafff2f115984d7f7e08624f257188"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "49836a418eb5955a99ea459f28c25bb2eb652ab1395e52f1dd1c924bd2030fc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "415a7b4883e98ea7dccdbb5148988c0b53aba6aff5bc2bee0bc24bb577b114ab"
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

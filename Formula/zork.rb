class Zork < Formula
  desc "Dungeon modified from FORTRAN to C"
  homepage "https://github.com/devshane/zork"
  url "https://github.com/devshane/zork/archive/v1.0.3.tar.gz"
  sha256 "929871abae9be902d4fb592f2e76e52b58b386d208f127c826ae1d7b7bade9ef"
  head "https://github.com/devshane/zork.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "506debc59ab6d891ce98da1bfe4c8a6e5604dc9a91cf225ed19fe3027544f3ea"
    sha256 arm64_big_sur:  "3f9f282ff618e0a31976bbae0b95e1fabcab2053cef50e2e54bce7877533bbec"
    sha256 monterey:       "6693bf5507881124657a5cbeb75fc6df3d2f21aafbecce1967212d631924a5cf"
    sha256 big_sur:        "d8138472c8d3b67db24ce72d03228081118aed98007d5280f6713f556fea337e"
    sha256 catalina:       "694460ddf13fb4e4f05ef49dde4472dcce56dbc7a945c99307d3e34e35301aa2"
    sha256 mojave:         "2c5a5b9e024a752e705b85c4420baf74aa27c5ed1088afbf043efadc7307aed3"
    sha256 x86_64_linux:   "b6205ffff9a5874f180fd92c609e23cbf079799d9c43523b9f05befde770f712"
  end

  uses_from_macos "ncurses"

  def install
    system "make", "DATADIR=#{share}", "BINDIR=#{bin}"
    system "make", "install", "DATADIR=#{share}", "BINDIR=#{bin}", "MANDIR=#{man}"
  end

  test do
    test_phrase = <<~EOS.chomp
      Welcome to Dungeon.\t\t\tThis version created 11-MAR-91.
      You are in an open field west of a big white house with a boarded
      front door.
      There is a small mailbox here.
      >Opening the mailbox reveals:
        A leaflet.
      >
    EOS
    assert_equal test_phrase, pipe_output("#{bin}/zork", "open mailbox", 0)
  end
end

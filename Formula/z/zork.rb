class Zork < Formula
  desc "Dungeon modified from FORTRAN to C"
  homepage "https://github.com/devshane/zork"
  url "https://github.com/devshane/zork/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "929871abae9be902d4fb592f2e76e52b58b386d208f127c826ae1d7b7bade9ef"
  license :public_domain
  head "https://github.com/devshane/zork.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "fdce85049ae42b1a9be9102f46045e7940a47b15e9a5994f08b954721f0ac242"
    sha256 arm64_sequoia:  "05e76a8e62d4bb0e55d7aa39d39b01082ac9f6dac9305feaccd466deb3e9b54c"
    sha256 arm64_sonoma:   "2abffab6441cae3c3ca7247d1f0d313571ae873f536fb647b605bec580688d55"
    sha256 arm64_ventura:  "ec4836e8f767968119feea70913b248475a549d10f9dc78f1777b0cffc78dde7"
    sha256 arm64_monterey: "506debc59ab6d891ce98da1bfe4c8a6e5604dc9a91cf225ed19fe3027544f3ea"
    sha256 arm64_big_sur:  "3f9f282ff618e0a31976bbae0b95e1fabcab2053cef50e2e54bce7877533bbec"
    sha256 sonoma:         "1baa8e6b8652a3e2097f4cf7bdd682aefc2257539ba3e2c128b67ead17a2dbe1"
    sha256 ventura:        "d3bee8f46195e47e19bf1772a6e2bc394f314d1730af2576590a65a24875a10c"
    sha256 monterey:       "6693bf5507881124657a5cbeb75fc6df3d2f21aafbecce1967212d631924a5cf"
    sha256 big_sur:        "d8138472c8d3b67db24ce72d03228081118aed98007d5280f6713f556fea337e"
    sha256 catalina:       "694460ddf13fb4e4f05ef49dde4472dcce56dbc7a945c99307d3e34e35301aa2"
    sha256 arm64_linux:    "a8c82f78501656b0426865983a27c1c722b5ef39ad4606cd15ee9239a312db82"
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
    assert_equal test_phrase, pipe_output(bin/"zork", "open mailbox", 0)
  end
end

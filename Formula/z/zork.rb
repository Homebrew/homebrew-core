class Zork < Formula
  desc "Dungeon modified from FORTRAN to C"
  homepage "https://github.com/devshane/zork"
  url "https://github.com/devshane/zork/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "df2934f886d9d225f27062a783df3f32d73151d32f53b20f37415492932837e4"
  license :public_domain
  head "https://github.com/devshane/zork.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "d7e9c0e08036a217ac15242a22fb0f823abf4ca8274966912ded4a3e9ed570c0"
    sha256 arm64_sequoia: "2b6f0b461fa78bf942403470af76b0ab1e52a4d1e63416d606451bd3c3fc78cc"
    sha256 arm64_sonoma:  "e600a9fe32aa02251f345633b61e5d35319789acc02d3793d4b6a1ca68614515"
    sha256 sonoma:        "1f8507e56b1534be36d9e3d879cbb82201c1bfe5e8e571c602cee116a6b9a3fe"
    sha256 arm64_linux:   "93c6e65c485bde0a27828a355d700cb710f102f8165df99810a347f9a52411e7"
    sha256 x86_64_linux:  "796ed4fc84b694a6914f440cca5f7cc3ecad16fe30922229c01dd240e5c66ad0"
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

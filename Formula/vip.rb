class Vip < Formula
  desc "Program that provides for interactive editing in a pipeline"
  homepage "https://www.cs.duke.edu/~des/vip.html"
  url "https://www.cs.duke.edu/~des/scripts/vip"
  version "19971113"
  sha256 "171278e8bd43abdbd3a4c35addda27a0d3c74fc784dbe60e4783d317ac249d11"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bc8d6d8704f33dfa59feb3b0784a731e2c8b23d79bccdcfcb0999b462b1f04f7"
    sha256 cellar: :any_skip_relocation, big_sur:       "3d8eaddf844f683c6eab2db5a4b3d2c2d4267df78a9abc4605c834f8f3543fa8"
    sha256 cellar: :any_skip_relocation, catalina:      "d49d0ecf58de93d03369024f165aae99210c2b72cffe4aadff7a2299236d7420"
    sha256 cellar: :any_skip_relocation, mojave:        "da936f8d9a839a1235962c772ae957563c13f089d5953df7c1ba64b694cb0687"
    sha256 cellar: :any_skip_relocation, high_sierra:   "5622623485848fc1e4238404c3491f056f4220c6a80fbe9342ec89cd34b15bcb"
    sha256 cellar: :any_skip_relocation, sierra:        "12eec6f5294a94f2fb09c54f218470aab2fb7bad58570e8a82c789d8ba5e9639"
    sha256 cellar: :any_skip_relocation, el_capitan:    "1bf2041f43bcea1e8c503119a9b34f8849b751da767ec5b5094fd5fa8fe5f297"
    sha256 cellar: :any_skip_relocation, yosemite:      "8e60ec9a240192f872f5d730ca93c9bc9e73d4644e685173554ff786b634ef7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd1eaee76c43cbe5384907f794d619db9b4d044eb54e223e0666e4da73f007e8"
    sha256 cellar: :any_skip_relocation, all:           "cd1eaee76c43cbe5384907f794d619db9b4d044eb54e223e0666e4da73f007e8"
  end

  resource "man" do
    url "https://www.cs.duke.edu/~des/scripts/vip.man"
    sha256 "37b2753f7c7b39c81f97b10ea3f8e2dd5ea92ea8d130144fa99ed54306565f6f"
  end

  # use awk and /var/tmp as temporary directory
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/vip/19971113.patch"
    sha256 "96879c8d778f21b21aa27eb138424a82ffa8e8192b8cf15b2c4a5794908ef790"
  end

  def install
    bin.install "vip"
    resource("man").stage do
      man1.install "vip.man" => "vip.1"
    end
  end
end

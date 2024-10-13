class Ssocr < Formula
  desc "Seven Segment Optical Character Recognition"
  homepage "https://www.unix-ag.uni-kl.de/~auerswal/ssocr/"
  url "https://www.unix-ag.uni-kl.de/~auerswal/ssocr/ssocr-2.24.0.tar.bz2"
  sha256 "bb2e1bb88fa96dab6934e8f0fa715aabe8a2e7a50832acc970ac0521c36b9a97"
  license "GPL-3.0-or-later"
  head "https://github.com/auerswal/ssocr.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "6ebbdb4bf24fffb7abcc1fdfc6b08806cc65a146319d86daee37bf59dc3d7dd6"
    sha256 cellar: :any,                 arm64_sonoma:   "dedbf881f748f45bcacba408299ae1b774cf652d7c7d0a982b34b7ba2ca4687a"
    sha256 cellar: :any,                 arm64_ventura:  "a7369ef42f86409f6ac67550e09ddcae5278b2742d3a9662416cc415f8fc393d"
    sha256 cellar: :any,                 arm64_monterey: "7c16418e11830b62d2abad7019c28e2a6ee2d02fe261762012ae5e30eeeaccc2"
    sha256 cellar: :any,                 sonoma:         "adaf1b5351ba16a96a61d93298da90435cdb70c4bd95e4222385997d18e17063"
    sha256 cellar: :any,                 ventura:        "cd539981162fc18780a3f07adc3d176e3e0dc3108ce9baef43804c3a5479ebc9"
    sha256 cellar: :any,                 monterey:       "818af7598aa1ece3734de4b9413700dbb95e6b43f8dbd53b64e2f249f8ff1e64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c612e5d1a5b67047699009bd3193889a7bdcdefb7c0b5541b642a4cde7aa49d"
  end

  depends_on "pkg-config" => :build
  depends_on "imlib2"

  resource "homebrew-test-image" do
    url "https://www.unix-ag.uni-kl.de/~auerswal/ssocr/six_digits.png"
    sha256 "72b416cca7e98f97be56221e7d1a1129fc08d8ab15ec95884a5db6f00b2184f5"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    resource("homebrew-test-image").stage testpath
    assert_equal "431432", shell_output("#{bin}/ssocr -T #{testpath}/six_digits.png").chomp
  end
end

class Tweak < Formula
  desc "Command-line, ncurses library based hex editor"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/tweak/"
  url "https://www.chiark.greenend.org.uk/~sgtatham/tweak/tweak-3.02.tar.gz"
  sha256 "5b4c19b1bf8734d1623e723644b8da58150b882efa9f23bbe797c3922f295a1a"

  livecheck do
    url :homepage
    regex(/href=.*?tweak[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a7fd74395285898f8a5d187c349de12b3cdb658b3b613e0dde445e1c679de808"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c5688f682787ca49543c2a6bed37237fc52c4ecd11707ec7d5688eaa60e9bf21"
    sha256 cellar: :any_skip_relocation, monterey:       "398bfc5cdc33b289dd14f243ba00a3bfc9281878588fd2995931931e87dfdeb8"
    sha256 cellar: :any_skip_relocation, big_sur:        "db84e159f437b7ba3c6592ee9564842e6d21823325777c2317acdda483d452bd"
    sha256 cellar: :any_skip_relocation, catalina:       "a38441e05b3953b324cee772161ebb1ccf12bf2262c476af921fee963fdee413"
    sha256 cellar: :any_skip_relocation, mojave:         "82ec40f5ceaee7630a9bba6652c350388176c38908681fe4389a37d2e9605009"
    sha256 cellar: :any_skip_relocation, high_sierra:    "e36456b9e78dafa97c7c972a9c26bc274cc30dff8f50c2a736d2aaca8068dfa8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44b7907316240a0b5efb6a1025c22664da20e509d1d7d9787a7bdaa060d4c06f"
  end

  uses_from_macos "ncurses"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}", "MANDIR=#{man1}"
  end

  test do
    output = shell_output("#{bin}/tweak -D")
    assert_match "# Default .tweakrc generated", output
  end
end

class Tweak < Formula
  desc "Command-line, ncurses library based hex editor"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/tweak/"
  url "https://www.chiark.greenend.org.uk/~sgtatham/tweak/tweak-3.02.tar.gz"
  sha256 "5b4c19b1bf8734d1623e723644b8da58150b882efa9f23bbe797c3922f295a1a"

  bottle do
    cellar :any_skip_relocation
    sha256 "a38441e05b3953b324cee772161ebb1ccf12bf2262c476af921fee963fdee413" => :catalina
    sha256 "82ec40f5ceaee7630a9bba6652c350388176c38908681fe4389a37d2e9605009" => :mojave
    sha256 "e36456b9e78dafa97c7c972a9c26bc274cc30dff8f50c2a736d2aaca8068dfa8" => :high_sierra
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

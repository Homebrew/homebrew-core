class Xplr < Formula
  desc "Hackable, minimal, fast TUI file explorer"
  homepage "https://github.com/sayanarijit/xplr"
  url "https://github.com/sayanarijit/xplr/archive/v0.17.0.tar.gz"
  sha256 "0464bab7eab77a6bd6051714161a369b3c7df76bbcbbba13c0b121d3c04b1207"
  license "MIT"
  head "https://github.com/sayanarijit/xplr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e094711e15cc5a834485447b2d84ff63b83a011128eefd56d66cebf808687b2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "236e42d90550c7948337589d9be17c2721211c191b9698937256e4ff72dcf0d3"
    sha256 cellar: :any_skip_relocation, monterey:       "c93067f88895c914e6136ed316d84ea10c3045717d1188f8d97f4aaa5aaa3e47"
    sha256 cellar: :any_skip_relocation, big_sur:        "04a52ba4c826624c9fd3ddc3d73b898bd080e5bca11763ce560584142b72a940"
    sha256 cellar: :any_skip_relocation, catalina:       "feb6ed13d78eab9aa0edb9511b2142fe2e21ea3745f756e63163dc64929da87a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe1838f941d4b052aecdcf5a3a6c52ed31df28ec567b34df5b876e3e1e9ed166"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    input, = Open3.popen2 "SHELL=/bin/sh script -q output.txt"
    input.puts "stty rows 80 cols 130"
    input.puts bin/"xplr"
    input.putc "q"
    input.puts "exit"

    sleep 5
    File.open(testpath/"output.txt", "r:ISO-8859-7") do |f|
      contents = f.read
      assert_match testpath.to_s, contents
    end
  end
end

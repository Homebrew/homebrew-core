class Xplr < Formula
  desc "Hackable, minimal, fast TUI file explorer"
  homepage "https://github.com/sayanarijit/xplr"
  url "https://github.com/sayanarijit/xplr/archive/v0.17.6.tar.gz"
  sha256 "3bd2798d5c22207ede1156c63131dbae72fa81fc4ec636067d9f9e6517cb999c"
  license "MIT"
  head "https://github.com/sayanarijit/xplr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "83cedec3a0caf86e0ae05d14427be346240ea8cf3df6128158dbe13e05eb1f42"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8d24e61c70b74f62bfdafaf11d24fa38f4ae27c7ded9307208975754139419d8"
    sha256 cellar: :any_skip_relocation, monterey:       "f5e6852fbfc43f1b1d6708fb5c90eda4cf20fbc3b718d89446b53d4ae47abb9a"
    sha256 cellar: :any_skip_relocation, big_sur:        "93eafd238e8201c2dd282ccef98b25109bc5c3797124a19b479904bf3817e8ec"
    sha256 cellar: :any_skip_relocation, catalina:       "7bcf3ff165970f4ae0e7d50e31f0a909c4a9e27e506c4b378f6e79d9b0930c10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d68c463cf8d858a8b4d632b8bf677b500be2271ad78daa880139ebc7548e9bb"
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

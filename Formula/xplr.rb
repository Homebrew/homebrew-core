class Xplr < Formula
  desc "Hackable, minimal, fast TUI file explorer"
  homepage "https://github.com/sayanarijit/xplr"
  url "https://github.com/sayanarijit/xplr/archive/v0.13.1.tar.gz"
  sha256 "ede30e4c0d0bb445cbb3f3eb8e5cfd9406048201e76ee54f099f5a963b921f4d"
  license "MIT"
  head "https://github.com/sayanarijit/xplr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7e7033ac4910bebe91b1b442b870719f71fd8fb815ede8dd3a524ba0d0e403d5"
    sha256 cellar: :any_skip_relocation, big_sur:       "31e39150a0686544583c3b4a455996af6c5efba22dc92ffb8c80287626cd5d1e"
    sha256 cellar: :any_skip_relocation, catalina:      "3466663841248203876e2e512073e9d6e1c2142ba45c7ed45301e35ee6cf7131"
    sha256 cellar: :any_skip_relocation, mojave:        "7de37eadf978f6ad9f872c5a25c480c9d0485f27a1023f69ae38e6ec56aa3faf"
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

class Xplr < Formula
  desc "Hackable, minimal, fast TUI file explorer"
  homepage "https://github.com/sayanarijit/xplr"
  url "https://github.com/sayanarijit/xplr/archive/v0.14.7.tar.gz"
  sha256 "2d91f4ee14b24832a8e1131793fb6033aab845da64d7fc7ee8cbe5c7003b8f38"
  license "MIT"
  head "https://github.com/sayanarijit/xplr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "83f5109503ff3c51fb8635a26908068d3dfbb1c1428a0606b945bdb5a23dc324"
    sha256 cellar: :any_skip_relocation, big_sur:       "9c0e2294f69987f12db7c1f743a17158823a9505fa216aab269a81a25dfc2d66"
    sha256 cellar: :any_skip_relocation, catalina:      "950eee5834469513c5afba39dcb34b5dc51f2dc1e2318fe6d645f81699d9a4c8"
    sha256 cellar: :any_skip_relocation, mojave:        "0eb3a9000830a955ee9da91d9201a85a9fe5d1f156922c9f415441ba5019ceaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77cd6bd9ce6b478ceb15b191e1638ef330124330d571fb43937da34defe7a73e"
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

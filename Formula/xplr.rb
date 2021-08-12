class Xplr < Formula
  desc "Hackable, minimal, fast TUI file explorer"
  homepage "https://github.com/sayanarijit/xplr"
  url "https://github.com/sayanarijit/xplr/archive/v0.14.5.tar.gz"
  sha256 "6cca4d5edd230b946cf19fdc614d7ee7622486c44b96cf5a17e95926f741c0dd"
  license "MIT"
  head "https://github.com/sayanarijit/xplr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f930efee8d6425abd90785c1935a21a21fe5d795106a1d04ba3f03cfdc430aa3"
    sha256 cellar: :any_skip_relocation, big_sur:       "294031ce904814080e8f84dc8cdc165655c714f4d8cffdf40dc52e6322bced70"
    sha256 cellar: :any_skip_relocation, catalina:      "4d2b35162e0320a1d81dfc3d251135c40ccb70d743416eb77246a0e3f3f36394"
    sha256 cellar: :any_skip_relocation, mojave:        "3f3fe748270289d01958f1e6b124826b700863282db4c963145235669d0445b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3baf1751e175126849ab10f2196b414450b37988dd2b4dea8a76f2c9c5a725a0"
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

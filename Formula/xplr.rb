class Xplr < Formula
  desc "Hackable, minimal, fast TUI file explorer"
  homepage "https://github.com/sayanarijit/xplr"
  url "https://github.com/sayanarijit/xplr/archive/v0.15.2.tar.gz"
  sha256 "f40fc7c7bdea44c919137d195f5c422285a65ecd46394c16eb68d293927b6c6b"
  license "MIT"
  head "https://github.com/sayanarijit/xplr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8fad7c30b06014fe57db2a8111d948230c2c8b7fe3f3bba90ca5ca4b293937ac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f4e52b1e94e56c416175e68aa0652d342d82c185b41fafc79d22f75706a36fca"
    sha256 cellar: :any_skip_relocation, monterey:       "48ee588eabf5d64a07f63767b74680eef94406b35528edba3a8d45965466a018"
    sha256 cellar: :any_skip_relocation, big_sur:        "0f7af04355bdf2ad8c947d87c74ca8e901a661763d2e0d3991ddcba01b643d8c"
    sha256 cellar: :any_skip_relocation, catalina:       "bdf19dce73a1a8f99847b5961180fb58b5ad3338ad03e0e7eea3f3da38ad37e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4dca7b891d1a4b30778ba48b7bb130a488a5fb9f20a5a4d3f09aa13617ace2d3"
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

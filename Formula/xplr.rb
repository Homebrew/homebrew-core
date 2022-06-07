class Xplr < Formula
  desc "Hackable, minimal, fast TUI file explorer"
  homepage "https://github.com/sayanarijit/xplr"
  url "https://github.com/sayanarijit/xplr/archive/v0.19.0.tar.gz"
  sha256 "3ffd1c6caf6d77b50744ba0c4166c149c8bb4bf66ad3012292bc54b4064d3779"
  license "MIT"
  head "https://github.com/sayanarijit/xplr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b32a67abdf62635958d93641224ce5e7f13f6cf1041c6eaae4e1686bd653025"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ac12e05ab17835249a1f489a0dc89e8033d618503d0202aa0a534533d46dda0c"
    sha256 cellar: :any_skip_relocation, monterey:       "d722558724aae9531bb61785bfb046402060adbc687bf8451cb2b0d03587e8c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "f7c543acdb20571d50d8dc5319836aff05e8cd5f410083b539d4f13cf46b645a"
    sha256 cellar: :any_skip_relocation, catalina:       "5c1c0109576455a27fb21074042238ed6831446e1c6c0777a2e9670db0f05e06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97eca15d57907527576af347791f7bb037a512dc32fab67348afaabc5c561f86"
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

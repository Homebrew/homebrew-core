class Xplr < Formula
  desc "Hackable, minimal, fast TUI file explorer"
  homepage "https://github.com/sayanarijit/xplr"
  url "https://github.com/sayanarijit/xplr/archive/v0.4.3.tar.gz"
  sha256 "d9df75d949085b0ed14a55a40a0132889e674f2851a0d3fd4c4cb4de54368e63"
  license "MIT"
  head "https://github.com/sayanarijit/xplr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b995057f911af00a6356cab3e178f56a2c1428b35d131cf07acea4e7c61f3464"
    sha256 cellar: :any_skip_relocation, big_sur:       "1b1563c02424988f3f535d13f16fd9f85ef7e7415472806f7a7b373a7c52a80d"
    sha256 cellar: :any_skip_relocation, catalina:      "c5202bf034f5073e1f29fd9940eb1305465e3e60b75e8bbc96b45a49c5b2590d"
    sha256 cellar: :any_skip_relocation, mojave:        "5f43b8d52c5a9ae0c2902ae1af431bbecae54cda2a604fe2b87b4be96f701439"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    input, = Open3.popen2 "SHELL=/bin/sh script -q output.txt"
    input.puts "stty rows 80 cols 130"
    input.puts "#{bin}/xplr"
    input.putc "q"
    input.puts "exit"

    sleep 5
    File.open(testpath/"output.txt", "r:ISO-8859-7") do |f|
      contents = f.read
      assert_match testpath.to_s, contents
    end
  end
end

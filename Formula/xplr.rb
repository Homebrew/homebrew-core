class Xplr < Formula
  desc "Hackable, minimal, fast TUI file explorer"
  homepage "https://github.com/sayanarijit/xplr"
  url "https://github.com/sayanarijit/xplr/archive/v0.14.3.tar.gz"
  sha256 "c51f26eeaf7419a1be1dc32604a4c61de53a48e373309ae61ece4599678ed98f"
  license "MIT"
  head "https://github.com/sayanarijit/xplr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b972ee2d9494020b11ad14aaf74150f2e169070140a0df323ed862a65495de46"
    sha256 cellar: :any_skip_relocation, big_sur:       "f97af0aa6300c7414cf06d7838ac42c06623b4b327016a7a4ea9d25329507c1b"
    sha256 cellar: :any_skip_relocation, catalina:      "2da666107723354eb591f3ff3d4eefef204f20a6b63c6f72acc3730c2ab8a544"
    sha256 cellar: :any_skip_relocation, mojave:        "b05509fa0da87553272d8e35419cb38a12d1057c410f7238b5745625d5794326"
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

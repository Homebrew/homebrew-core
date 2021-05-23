class Xplr < Formula
  desc "Hackable, minimal, fast TUI file explorer"
  homepage "https://github.com/sayanarijit/xplr"
  url "https://github.com/sayanarijit/xplr/archive/v0.10.2.tar.gz"
  sha256 "858a795b9b7193e0ea0b9f617022fa4f2ce0322cd0ea7f3d5fae83594501e8ba"
  license "MIT"
  head "https://github.com/sayanarijit/xplr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "81acf27aef7c76e1785a92c136e3c1a8c8e8db1694278357f98d3c6700d3fa77"
    sha256 cellar: :any_skip_relocation, big_sur:       "5f5a43c9408e2bac79358563b315d5b2cba4afe2b499784bc8cb41bd563321da"
    sha256 cellar: :any_skip_relocation, catalina:      "d9d80277814f0db8590190ba5d4fefa85660f246257c1a85d2713eb0dae402ce"
    sha256 cellar: :any_skip_relocation, mojave:        "83174fac8f5fffcbfad7a0b007ee3515b65db24c8f2157817ba21df2c4fbf5bf"
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

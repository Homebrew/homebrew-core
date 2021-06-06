class Xplr < Formula
  desc "Hackable, minimal, fast TUI file explorer"
  homepage "https://github.com/sayanarijit/xplr"
  url "https://github.com/sayanarijit/xplr/archive/v0.14.0.tar.gz"
  sha256 "63d6f85880a8877ef38d4e77aec5ae74e40f96208a12f9d08e43ab19527dac36"
  license "MIT"
  head "https://github.com/sayanarijit/xplr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4ebe420cda6d582cc3fd7dc27d6566bf8629a8fa844fd86e9f3eb142325b3ec1"
    sha256 cellar: :any_skip_relocation, big_sur:       "a272be02ac27a2ebcdba18637bfeec8a7224f1f9c5c2b8c0b33dde2132842d68"
    sha256 cellar: :any_skip_relocation, catalina:      "e184114c111be4fd4895d943889db3fc09f464c3dd8dd41a6071fae9e27ff3c8"
    sha256 cellar: :any_skip_relocation, mojave:        "2a8abbfa52807d6b3667a8da981f2d90416b7870ccb52b947ae6171bc6dda9dd"
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

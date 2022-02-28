class Xplr < Formula
  desc "Hackable, minimal, fast TUI file explorer"
  homepage "https://github.com/sayanarijit/xplr"
  url "https://github.com/sayanarijit/xplr/archive/v0.17.3.tar.gz"
  sha256 "73f1dd760054749cf3b069f8be44e39dbc14684a384cc6fe260eb85f3a04d06e"
  license "MIT"
  head "https://github.com/sayanarijit/xplr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e1ba5919879ca88058860b81be576c5367d2a71c7722cbbc17976f742bbbccd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "04f7c4ec3b3039aec32e453fac171cc6a9964e1045f7d1f39b763c12b19037a2"
    sha256 cellar: :any_skip_relocation, monterey:       "a7f2814610a6e259b471df9f8761ca402c7f4ba18b8c62dd24632d5b5b602c17"
    sha256 cellar: :any_skip_relocation, big_sur:        "ef552823aa02a4fd97b55c95197860a6325bdaf82588e0a5976bf074ade12456"
    sha256 cellar: :any_skip_relocation, catalina:       "6cd2d865934c45fbab63945458b7668b81a72803a0de278e094f81cd2b0fb086"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a34b115486e1f50835bc4efd79c64b6912cb65567d4c3cc8bfd9066b74cd3d73"
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

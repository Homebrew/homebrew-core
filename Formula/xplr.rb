class Xplr < Formula
  desc "Hackable, minimal, fast TUI file explorer"
  homepage "https://github.com/sayanarijit/xplr"
  url "https://github.com/sayanarijit/xplr/archive/v0.14.4.tar.gz"
  sha256 "c007d462661619257622283db1c91055e57673b9792947d079cd1286a2371b95"
  license "MIT"
  head "https://github.com/sayanarijit/xplr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "53f455b23b5e761761fec939891047782baa7fe311e576b402315ac3d2ab12b2"
    sha256 cellar: :any_skip_relocation, big_sur:       "1ab72067218dfd15d12e7f2b93f613b269961c7edba142d46bd3b48dbbc508b2"
    sha256 cellar: :any_skip_relocation, catalina:      "6366c53d24b1289bacbe3cf390718f3bd2b3ef131f140a212740aa8ad19ea890"
    sha256 cellar: :any_skip_relocation, mojave:        "a85b177314511587ced783030116773bcfca6135c93c63c7aa958d8b233bae0a"
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

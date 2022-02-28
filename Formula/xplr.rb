class Xplr < Formula
  desc "Hackable, minimal, fast TUI file explorer"
  homepage "https://github.com/sayanarijit/xplr"
  url "https://github.com/sayanarijit/xplr/archive/v0.17.3.tar.gz"
  sha256 "73f1dd760054749cf3b069f8be44e39dbc14684a384cc6fe260eb85f3a04d06e"
  license "MIT"
  head "https://github.com/sayanarijit/xplr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ff8a1defb3b4ab9d3b033b9fa7b485ec338e6f1515083848ddd418fabc182cd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "31a36975f9b19effb63dae071fca7f2b8197bbd9bda0832385fd0ae214da4842"
    sha256 cellar: :any_skip_relocation, monterey:       "12b5c04319504fabf28851e22a75a6214569a8496862f933a2a0e113fea27ef2"
    sha256 cellar: :any_skip_relocation, big_sur:        "8f4fd4282a0e879aa0cdaf6aeb1633c35fa16319340a7e1ca3b4ef81d0c29679"
    sha256 cellar: :any_skip_relocation, catalina:       "bfa31a14a01d457935fd653f9ae78fe840c5bdca18e46892379a94710310df88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0395b53640218b49e238d3c3e265085d568187a612b10b46bba774bef03c0f0c"
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

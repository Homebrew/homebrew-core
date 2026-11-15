class Xplr < Formula
  desc "Hackable, minimal, fast TUI file explorer"
  homepage "https://xplr.dev"
  url "https://github.com/sayanarijit/xplr/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "25029a01d5c849cede183ec7bccc6c8bdb4e68c8070d573b288169671dc3ee3e"
  license "MIT"
  head "https://github.com/sayanarijit/xplr.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c49b4cf0cd872bdcf451a12eede23634f338f1f6ebd72f6f4ec933c548780e00"
    sha256 cellar: :any, arm64_tahoe:       "92895a7d0f1891b03c1b346156b53ff6c2ca571dbfee47a607424290eabb0b59"
    sha256 cellar: :any, arm64_sequoia:     "fc30d537eb34fad2c3716bd78109d1bbf7a8734e2eb59cd3492e3dbf8b34aa52"
    sha256 cellar: :any, arm64_linux:       "a5e2ad47c5a58f7826ec2af8aea1a2cdbf7050b3b13332981d69ea7ba437ad1f"
    sha256 cellar: :any, x86_64_linux:      "26b3866701e1006078cc8b512e7f1a21422ee9c19851337c8240ad9b6508c5a6"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "luajit"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args
  end

  test do
    require "utils/linkage"

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

    assert Utils.binary_linked_to_library?(bin/"xplr",
                                formula_opt_lib("luajit")/shared_library("libluajit")),
           "No linkage with libluajit! Cargo is likely using a vendored version."
  end
end

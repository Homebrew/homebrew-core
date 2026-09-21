class Xplr < Formula
  desc "Hackable, minimal, fast TUI file explorer"
  homepage "https://xplr.dev"
  url "https://github.com/sayanarijit/xplr/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "d483574fcf2510bee3c8e11d01301bf0402891d83a6dcce6132be438eb46fc6a"
  license "MIT"
  head "https://github.com/sayanarijit/xplr.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "98db3ba3c1ab24d462f4e5198c7484dee9743a0c31152d317234fc6ea7875c2e"
    sha256 cellar: :any, arm64_tahoe:       "2e152dcf397889bf85dbc1f56f4d795578ec6430372d4bbaef74c646db0cf898"
    sha256 cellar: :any, arm64_sequoia:     "d52eb5e01d62230935d762e096fca0f54e5ddfae3f6e05c11f51b31e1897e2ff"
    sha256 cellar: :any, arm64_linux:       "740d663e8b023e69d660d1a0d2f1b0757f5f766b5fa534ee2bc824f742bea6d9"
    sha256 cellar: :any, x86_64_linux:      "b2497f79d647e0c9115d784415046c5b28526d1e5dedcae7dddee9ff8174396f"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "luajit"

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

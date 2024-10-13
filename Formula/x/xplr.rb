class Xplr < Formula
  desc "Hackable, minimal, fast TUI file explorer"
  homepage "https://github.com/sayanarijit/xplr"
  url "https://github.com/sayanarijit/xplr/archive/refs/tags/v0.21.9.tar.gz"
  sha256 "345400c2fb7046963b2e0fcca8802b6e523e0fb742d0d893cb7fd42f10072a55"
  license "MIT"
  head "https://github.com/sayanarijit/xplr.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "723d64bfe826b1e4114a3804f7561e1491fa85ea21155fb59623d73a8e33da31"
    sha256 cellar: :any,                 arm64_sonoma:   "e12c3daf98f01ef65c0712449f17b2e44941ae864468139028df465b5e6714f9"
    sha256 cellar: :any,                 arm64_ventura:  "a5e3d5b13f3fae8554777905d97a8a5b5de096de7218f541d34059304b5f7dd1"
    sha256 cellar: :any,                 arm64_monterey: "4fead8b01327480386b45f7165f05c47dce16e3f575e15f74128739dca1f23ab"
    sha256 cellar: :any,                 sonoma:         "251c75b3051e9e98a746ee31735042c7067e2269bd31e38aea2b7c1421d1c3aa"
    sha256 cellar: :any,                 ventura:        "3293d23dcbd6c3b440b053c439eb662234ea9b9beb5f5a71365fb949e2354a40"
    sha256 cellar: :any,                 monterey:       "bf794adee15ca2eabac6aa3d5ac1cab694a76bd2b787cbd15915b486b02485ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2e5fd49885a71195c2c9e6087e3b8d2f1b6b9c4a866be343db5fd1e067d5915"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "luajit"

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
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

    assert check_binary_linkage(bin/"xplr",
                                Formula["luajit"].opt_lib/shared_library("libluajit")),
           "No linkage with libluajit! Cargo is likely using a vendored version."
  end
end

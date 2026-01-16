class Xplr < Formula
  desc "Hackable, minimal, fast TUI file explorer"
  homepage "https://github.com/sayanarijit/xplr"
  url "https://github.com/sayanarijit/xplr/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "7948683c546fdf374f6bec7855726cf4e3f1bc4abf1c2a292cbdfa6ff16f6143"
  license "MIT"
  head "https://github.com/sayanarijit/xplr.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "81fd46b952f4e77c21f80a2ed0846d6eab2f427448b6c419968e035134cebc45"
    sha256 cellar: :any,                 arm64_sequoia: "d45b3241a18aa1600ac9f7a28e91aeddd802c0276c5e60c684a83e5df7d84248"
    sha256 cellar: :any,                 arm64_sonoma:  "3ebef346bbdf33d58fee01f749fbc82cf3da11815573df193baaef401d8071ce"
    sha256 cellar: :any,                 sonoma:        "3d3e87f43f39d456b01d425f102d4cdc6e775c131b515a7d8e2571a00be46d75"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb602d89f46080d0da072cdc9496fb9e150c86aa15bc8defe3aff9cab9ef887f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "580c25a69c5e025bc2ca4c26a6c9ceb0344ddbef285d87589d3df58d7a221b4c"
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
                                Formula["luajit"].opt_lib/shared_library("libluajit")),
           "No linkage with libluajit! Cargo is likely using a vendored version."
  end
end

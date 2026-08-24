class Xplr < Formula
  desc "Hackable, minimal, fast TUI file explorer"
  homepage "https://xplr.dev"
  url "https://github.com/sayanarijit/xplr/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "6f63a3394ad330cc80648448924d8c6dd848514707228d869ff27e35562804ff"
  license "MIT"
  head "https://github.com/sayanarijit/xplr.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3d1e313aef234ea5747bb149eccb2aaff676f27ef4c945455c334185103240e7"
    sha256 cellar: :any, arm64_sequoia: "d2bdeb506ec05cd636e6ab2c9f1f01cb0b1f7bc7cd101179c0ca159766a139c3"
    sha256 cellar: :any, arm64_sonoma:  "f1999d17311b9254f14b7bfa6baa48fffda5dc5dfc09d36a6edfc1fb2f75e5ed"
    sha256 cellar: :any, sonoma:        "7a2306b2f0ff06a99b014da3888dbea01dda241dc3b9d3bcc7473260b8d5476f"
    sha256 cellar: :any, arm64_linux:   "107a95f684327d775436f363e5620fb47821a439d5c448132ce56f5443db4abc"
    sha256 cellar: :any, x86_64_linux:  "1b91f970fd1acb2e70e4f2f9cf386a2b775a820a77fa7845815ab925a9460dc1"
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

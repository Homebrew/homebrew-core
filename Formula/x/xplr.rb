class Xplr < Formula
  desc "Hackable, minimal, fast TUI file explorer"
  homepage "https://github.com/sayanarijit/xplr"
  url "https://github.com/sayanarijit/xplr/archive/refs/tags/v0.21.10.tar.gz"
  sha256 "9d0201dd6beff259a614a6e38f7f321f1cbefd191d661fc70506c2ffd1501e33"
  license "MIT"
  head "https://github.com/sayanarijit/xplr.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f9eaa658097641c0fa8f7e22485f999ce387f12da37e3155e0a95985f371d05d"
    sha256 cellar: :any,                 arm64_sonoma:  "59e01ce7973743bfddbbb899edb5a18a528c4085f174c21f0c62b0c71b760ed1"
    sha256 cellar: :any,                 arm64_ventura: "a6a516ea9b316565240eb6ab74f86ef38d0e470d1f8a1a979b620f3d76bebb15"
    sha256 cellar: :any,                 sonoma:        "2110581699fb59d12ed1a543303557bb29b20d4a10f24b0ff05c166398ed1a54"
    sha256 cellar: :any,                 ventura:       "0974586bbdff2bae5f202b0bee0f1cee55e31d981adec4fe409e931965b4eefc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2a82eb69fe0bbe7d3ab5d893e5da3915c632cec3e531c9d8625048272456e0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "008b23323fabdece401987b87a8ccd6ac77ed38cebbc14d7e5b6a0d80196e086"
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

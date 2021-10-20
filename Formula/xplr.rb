class Xplr < Formula
  desc "Hackable, minimal, fast TUI file explorer"
  homepage "https://github.com/sayanarijit/xplr"
  url "https://github.com/sayanarijit/xplr/archive/v0.15.0.tar.gz"
  sha256 "c6a4252e100e9880ff0952f89d85e5c6c930b55b5452ef2d8ddf6e38ab1d98a4"
  license "MIT"
  head "https://github.com/sayanarijit/xplr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b675d21a2bb94e77ee93d0dcaee235ee74baf401148010292b5a143ad0a15bc4"
    sha256 cellar: :any_skip_relocation, big_sur:       "096d019745c14afbc38d058a5954d033a32c43572c48e914fcba4d141fdc84c9"
    sha256 cellar: :any_skip_relocation, catalina:      "f2df91d88f5a9fab7a8095b4ed5c92d305327a41396b44282f7f4f065d3610e3"
    sha256 cellar: :any_skip_relocation, mojave:        "b00779c2ceb5a74724bc074bd326e9e68076b9818a867ed1caa7dbe329d6f6e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a629fc8e031992b45b61a147fe7930e25679dc023b8061255124b1470d083b18"
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

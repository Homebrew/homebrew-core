class Xplr < Formula
  desc "Hackable, minimal, fast TUI file explorer"
  homepage "https://github.com/sayanarijit/xplr"
  url "https://github.com/sayanarijit/xplr/archive/v0.13.7.tar.gz"
  sha256 "eada28216a368b5366d99f4aab5f45d803a7223446273519c76c1202ade57b04"
  license "MIT"
  head "https://github.com/sayanarijit/xplr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f9a9b3947f656201474bd9576ac9f6954abc102da3f7ec007162688ad0db7acd"
    sha256 cellar: :any_skip_relocation, big_sur:       "a228d3ba9a934ea72218b9e4f36a5c6251b7e53e78adb44f04e1c3ac9e626ab6"
    sha256 cellar: :any_skip_relocation, catalina:      "4f372e515bcb1f01363f1ff08ff1e03c6d9c542c11936549cec2f13bdac8f1ff"
    sha256 cellar: :any_skip_relocation, mojave:        "1abc309a8e0cfb186582809eb6f3eab7b23b7f357732c60db7b140e764e90ea8"
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

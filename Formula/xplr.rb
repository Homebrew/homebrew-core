class Xplr < Formula
  desc "Hackable, minimal, fast TUI file explorer"
  homepage "https://github.com/sayanarijit/xplr"
  url "https://github.com/sayanarijit/xplr/archive/v0.14.2.tar.gz"
  sha256 "a51e6b43601530b79d306a9248387ad804f1b20158b2df376aa3a3d112e8de6e"
  license "MIT"
  head "https://github.com/sayanarijit/xplr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "68988d6d8f6e4fde001ec9c0678fd7bc7df99f7146a05f648eca555db65cdb99"
    sha256 cellar: :any_skip_relocation, big_sur:       "a2a9bfc0abefe8cff0adf0e5c1248fe316ae7cedcc644e3036de355c14404e25"
    sha256 cellar: :any_skip_relocation, catalina:      "cfc1493b23a4ce7c241fc5cb00b419142da5784c681a5a2ee0129b5119bec647"
    sha256 cellar: :any_skip_relocation, mojave:        "db83eef075331dc083d3fa3c20557e7a5239b6ccfa523e7835a85d848240d21f"
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

class Xplr < Formula
  desc "Hackable, minimal, fast TUI file explorer"
  homepage "https://github.com/sayanarijit/xplr"
  url "https://github.com/sayanarijit/xplr/archive/v0.5.13.tar.gz"
  sha256 "cc705c0f3eedf88ec8c22adb4d8629e66a8bf5ad55ccb4e24a1d6d4a7de6d29f"
  license "MIT"
  head "https://github.com/sayanarijit/xplr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b5bbf884dbf3af12770877f643ff1401bcfe597919262bcb5353213e5371e00a"
    sha256 cellar: :any_skip_relocation, big_sur:       "3a852acc80a2cf98acda6b119fe47fe849a7632166914f8d97c44cb1a067ffc9"
    sha256 cellar: :any_skip_relocation, catalina:      "fc0143c374106e3b83b72e769b8cd62aa2d8eae3247dde92901cc0b22a293b62"
    sha256 cellar: :any_skip_relocation, mojave:        "7db04e3ff062b1d9458ee82cf977b76f2ce637ea66f2b65a36e2f7a611226f72"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    input, = Open3.popen2 "SHELL=/bin/sh script -q output.txt"
    input.puts "stty rows 80 cols 130"
    input.puts "#{bin}/xplr"
    input.putc "q"
    input.puts "exit"

    sleep 5
    File.open(testpath/"output.txt", "r:ISO-8859-7") do |f|
      contents = f.read
      assert_match testpath.to_s, contents
    end
  end
end

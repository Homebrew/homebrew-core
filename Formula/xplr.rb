class Xplr < Formula
  desc "Hackable, minimal, fast TUI file explorer"
  homepage "https://github.com/sayanarijit/xplr"
  url "https://github.com/sayanarijit/xplr/archive/v0.17.1.tar.gz"
  sha256 "94040d4b45f41b81ed71ff1e124e3db2f9e4e8f3e11c3ec76315df5bab68351f"
  license "MIT"
  head "https://github.com/sayanarijit/xplr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13bc6600cd048b09918bced55b0bf92e5f36844c91ebf3e0da69eb239c24f175"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "df9c3255e409e8465c5df7b49d102f0d02b950b7bfca569590e2aee2475b899b"
    sha256 cellar: :any_skip_relocation, monterey:       "6aa5b5274cd0caa90709b77fa18cfcb1d23a4d9ade91b98071cb7837ab07e535"
    sha256 cellar: :any_skip_relocation, big_sur:        "5e7ecf289dd7b0a759550c50447aef22d1a1be15217f0763c8a00a663e65a03e"
    sha256 cellar: :any_skip_relocation, catalina:       "35018f2de0e20d801cf66cead1324659c5ef4c5987d938941a6686f4fe5d0296"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "079de1e29dd68e98c7d5b55595f5b4e5a59c6fa492e3b5312fc2ad956aa39988"
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

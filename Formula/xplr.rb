class Xplr < Formula
  desc "Hackable, minimal, fast TUI file explorer"
  homepage "https://github.com/sayanarijit/xplr"
  url "https://github.com/sayanarijit/xplr/archive/v0.20.2.tar.gz"
  sha256 "19e7f9d2c9644f3a88cda98cab5b1780b55df68ce3e2323555537837e6630583"
  license "MIT"
  head "https://github.com/sayanarijit/xplr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aaca13180ea8a8fda0b5cebf660ad7de5c95610db02c4dfb31c5b85648012308"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ffccfdec9f64ae0397a3743c4289bc8e11c8f05e74f21efcd254cb4162303d81"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5d5ff27c118c46acce0f97d43122998acf7fdab21db7b36ea46e68e558bcacf1"
    sha256 cellar: :any_skip_relocation, ventura:        "c9db10c0ce23450b413d0e42ed9f68c7d76dda86eb0992d5499629c156198aba"
    sha256 cellar: :any_skip_relocation, monterey:       "08a6f0435835fe7a9b1ab3c16e7af0eaba5f96274e204f836b46f090cdeb9e68"
    sha256 cellar: :any_skip_relocation, big_sur:        "0f05fb68868c4fd0eb61943cfaff3a5e26503bc0b5d9e0c50e2d16e5723c645f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68e2277479bc67932d61aee527a417ce6c5a0953392816fc3519e48ff40de42d"
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

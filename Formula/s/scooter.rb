class Scooter < Formula
  desc "Interactive find and replace in the terminal"
  homepage "https://github.com/thomasschafer/scooter"
  url "https://github.com/thomasschafer/scooter/archive/refs/tags/v0.8.4.tar.gz"
  sha256 "2feb7eb9f53d072276d40b01891919e41b668aaaeee43ca60ea9a7fb4d65d60f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9d853ae787b62b739a2828ee760aacae5f4d844d2a7e5f97f2c7094efa5b4a95"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "817362c317db80228dcc6df3f0d0d9975fef038c2690521a70e327fdd2ee5d45"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "161464661000e864201116496bc0f1b95a6fabd2d2d4a2e88165a44f1187c144"
    sha256 cellar: :any_skip_relocation, sonoma:        "1606b505ad796758d4e878256c14a9b77cfdb5f7c1126bc96ce7a81fe3abaefc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "332bedf968ea1b393130b98120298909ed532204b2af31a0d18cce161398b3fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab77fa4fd623c9ffdc954af553a42b1b45dfd03e8af77e0ed2af93d268e787a9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "scooter")
  end

  test do
    # scooter is a TUI application
    assert_match "Interactive find and replace TUI.", shell_output("#{bin}/scooter -h")
  end
end

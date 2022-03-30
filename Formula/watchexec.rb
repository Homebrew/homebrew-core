class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https://github.com/watchexec/watchexec"
  url "https://github.com/watchexec/watchexec/archive/cli-v1.18.11.tar.gz"
  sha256 "bdd5af45ab7e5981eed25ac09767388aa1fbf711a9d286bcb99884464980af5b"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb884263c2c2db6037d307e0160b8b0330f66a074263f0003674b42274658ebb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "367ea3a171d1db7be77b6271e0655b7e146a083210e0f25127e4cb33a3423346"
    sha256 cellar: :any_skip_relocation, monterey:       "e8373e9f94ffc39d241113ca8d358923c8329e2b0b8a26090694cbed8bdf7e47"
    sha256 cellar: :any_skip_relocation, big_sur:        "4d8efb0ee131cfa4a02c8ceec17d894af53812614475b1815dbf373555c0a8e2"
    sha256 cellar: :any_skip_relocation, catalina:       "2038898bb96ac541fb1799a8175f34ef4844aed10ed2fc6e5207ec80eff9b097"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d9c41c1169bebba009bd6425c4fb820967b12802f6885c6ef6a457654399786"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    cd "cli" do
      system "cargo", "install", *std_cargo_args
    end
    man1.install "doc/watchexec.1"
  end

  test do
    o = IO.popen("#{bin}/watchexec -1 --postpone -- echo 'saw file change'")
    sleep 15
    touch "test"
    sleep 15
    Process.kill("TERM", o.pid)
    assert_match "saw file change", o.read
  end
end

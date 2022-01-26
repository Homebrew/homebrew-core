class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https://github.com/watchexec/watchexec"
  url "https://github.com/watchexec/watchexec/archive/cli-v1.18.4.tar.gz"
  sha256 "7d4f285fa3bfd48452532516cb11fca26aa57bfedf772b45262defef0fcf1aa6"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee8e828ec0b669de511fde1001cd10d1d28953c0323b4a0cd5e92d3d9b3158cf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "191e54c5c4133da8d1fb4e77ad950fd130d0f2d3f57c7eadc9ce8d9ceb3fb0ff"
    sha256 cellar: :any_skip_relocation, monterey:       "bab72827c138630199052dbb18a6640b4a599aaf4bb8e3ab71df4fef92cb91f1"
    sha256 cellar: :any_skip_relocation, big_sur:        "86a40ae089254a4b85ec197127b08157c59f8b95e1e33f12ccc6202d881dc023"
    sha256 cellar: :any_skip_relocation, catalina:       "a6dca56204ba145bc9cfea99a7207295a941bbef041f1ea39b2c823b84c4581d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d037596a413940990258e31d154a3455ba37613701f2082e9864085bdf846e4b"
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

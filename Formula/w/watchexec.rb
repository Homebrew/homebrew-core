class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https://github.com/watchexec/watchexec"
  url "https://github.com/watchexec/watchexec/archive/refs/tags/v1.22.3.tar.gz"
  sha256 "698ed1dc178279594542f325b23f321c888c9c12c1960fe11c0ca48ba6edad76"
  license "Apache-2.0"
  head "https://github.com/watchexec/watchexec.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:cli[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4ae9d3c73b16b82ea33f71f443f6fe2a6a9fdfea88a2fc52e23a690522598f40"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "74bb10397923802ffd6d6f1da2e24bb79e03501aeacb8bb5cb856af25d9c1614"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f25e5a2ffe2c5179bf322d25568d19e60a1fd439dd189f40f527ff4319b2291b"
    sha256 cellar: :any_skip_relocation, ventura:        "fd5e0a49079d6eedef46b27d4cf167cd0ddb0e12c79d9652dd6c3c8c07f8d1c7"
    sha256 cellar: :any_skip_relocation, monterey:       "18751052458ba233a489ee07d0ea55b86061b3b72c511aec6010aa8ffe9aac9f"
    sha256 cellar: :any_skip_relocation, big_sur:        "f2110a8eb92f4bd7163fec5dafafc7ae152fa2f82d8e9d4d0c1e98a35341746c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58abe3ed90971e6fe00290562060e882c8e7d80a00aaa0aa724eb091da3e4e5c"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
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

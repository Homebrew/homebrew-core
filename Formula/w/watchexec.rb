class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https://watchexec.github.io/"
  url "https://github.com/watchexec/watchexec/archive/refs/tags/v2.7.0.tar.gz"
  sha256 "b9860e46ed035ba870b309eea4151f29f9eddb6e168712112545bfda11acc594"
  license "Apache-2.0"
  head "https://github.com/watchexec/watchexec.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:cli[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "60e619840aa29d5e87004db395ebc67d466654ba9f3c591f6568c4fb0d9cceb5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c41aa0dfdfc7fc12ec5d369f8923b345daad69d6d852e8ed227c8da8a5e8c6f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "244472d62fd2244fde0bf5f7e81099aa03c1cec92ee38fc436cecfeb8ee98e1b"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9d6ec17e3cc734aecb187c83a9f8eb7ca14d982944e706b85473361f680063d"
    sha256 cellar: :any,                 arm64_linux:   "f10f62cf8a9a37a594303313bb80f6268130f07a2301b03977df5ee3b2cbb060"
    sha256 cellar: :any,                 x86_64_linux:  "778e33d0d4ba201eaf517e1fea74699ffe7e669ba3a1dc592e3c35aa8ab5511d"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")

    generate_completions_from_executable(bin/"watchexec", "--completions")
    man1.install "doc/watchexec.1"
  end

  test do
    o = IO.popen("#{bin}/watchexec -1 --postpone -- echo 'saw file change'")
    sleep 15
    touch "test"
    sleep 15
    Process.kill("TERM", o.pid)
    assert_match "saw file change", o.read

    assert_match version.to_s, shell_output("#{bin}/watchexec --version")
  end
end

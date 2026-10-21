class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https://watchexec.github.io/"
  url "https://github.com/watchexec/watchexec/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "861496cd1e7d8546f770551893077e9b898fef1a6623d5e2207cf28c932e7738"
  license "Apache-2.0"
  head "https://github.com/watchexec/watchexec.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:cli[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "06253ec98bf073e87ed273c9d8d38b206ce0e320a7f4b9547829f7b8240be04a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bd364a09d34d2f5de531027df09516add5c78efcd0a4da7238a7f236d697bab9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "75c3f6eadff6ce962697e1119564a6afdbc75a9eb408dac255c87be2cc1b8436"
    sha256 cellar: :any,                 arm64_linux:       "95acf3788869fcdb7392971f22c297b06892a87239e9de75fe335390bcfa7630"
    sha256 cellar: :any,                 x86_64_linux:      "9b5a10ec79f90db758e276c68fce081fa0c93690cd943c61c44bf9437db7cc00"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
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

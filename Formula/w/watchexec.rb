class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https://watchexec.github.io/"
  url "https://github.com/watchexec/watchexec/archive/refs/tags/v2.3.3.tar.gz"
  sha256 "8d897bc79d6e6a381ad9b3abf2a4967b58bc376bdc0aa418bb99829660d74aff"
  license "Apache-2.0"
  head "https://github.com/watchexec/watchexec.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:cli[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a08fa2bda737115e8bf79603ee1ea7ba4d96039d0b3d8188e83861a553c6aa29"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee01cb30d9b797128795c6a4c23db7a0b72d6f607ceebf3f121b0e43af1ed77c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12ba9c2b99ae6495c51e6c2acebd1e325c0b97bcc34d05b0ecd69a830a9254ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "f476864d8dca7f8d86a7c220c6d3b9bcc84911b9df0ca6ee04696fb6075f9cef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8d40c84b0023fb07225fbd21af6332bd687bc1a0a7744db56690d4e5b6944d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf4a626762106499d834c92742695c946af7f27f2d6818cd10ab82e96e011b06"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

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

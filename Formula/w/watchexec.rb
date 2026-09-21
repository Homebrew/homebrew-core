class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https://watchexec.github.io/"
  url "https://github.com/watchexec/watchexec/archive/refs/tags/v2.7.3.tar.gz"
  sha256 "6f395178a963ffd478f0ee2e13146d375e8bbe4fec6859a56a0086a90e07e6f2"
  license "Apache-2.0"
  head "https://github.com/watchexec/watchexec.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:cli[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "796535e5ddc7b3341f61716f8f811d32c82f06856eeb4e1dff6fa518a3bf844c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7ac49fafa5b4538036979dfc4e0965eb6ad1165805ea97fb70745521c42118d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2014c7b3fca00160164812bc7ec30edd37a3c0bb16a2f48886079b5a514b4f5b"
    sha256 cellar: :any,                 arm64_linux:       "6dc835c27a2f788569337748141a242f9a856f9927c2d50d7ac2a26e7f0aa311"
    sha256 cellar: :any,                 x86_64_linux:      "f476d8a8a4bc6e6f6ff16a989bf67479953b4c57d39dc6c5d1fad94b1aac8200"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked", "--target", "host-tuple"
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

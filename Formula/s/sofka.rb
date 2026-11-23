class Sofka < Formula
  desc "Kubernetes TUI, reimagined in Rust"
  homepage "https://github.com/nklmilojevic/sofka"
  url "https://github.com/nklmilojevic/sofka/archive/refs/tags/v0.38.0.tar.gz"
  sha256 "bacd4a5b114ea0d617381ba6a76022e0bf10144ddfa6c14cf9fbc7deeeb57163"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "5cc4a1f7b0955e83a55e656d274c5ada6dde6229cdb3c8092a3bfd7f3a39ed12"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fdb91fbb68d5c6363d9f8000862a3af7252987bf8e389b2f385c88e9212d5cf3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d0f015b8b554b51b9a3cda86fad450e1b86d7494b9bdd9c2a427bd30bfce1d3a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "08286c42aaf8061406fdfb668da20932771d5f80e4130ce3de6c428a3994dd86"
    sha256 cellar: :any,                 arm64_linux:       "2bb2cc6a3f135943870113cdd451fc2caa35c1c69177b85a8cc2a6ddc6f43a2d"
    sha256 cellar: :any,                 x86_64_linux:      "2cc7fdd0c473fc393e022cc9b8d40971f7d5205d68df0a909f07c308f634c586"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"sofka", "completion")
  end

  test do
    assert_equal "sofka #{version}\n", shell_output("#{bin}/sofka --version")
    assert_match "failed to read kubeconfig", shell_output("#{bin}/sofka --check 2>&1", 1)
  end
end

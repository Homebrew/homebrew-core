class Sofka < Formula
  desc "Kubernetes TUI, reimagined in Rust"
  homepage "https://github.com/nklmilojevic/sofka"
  url "https://github.com/nklmilojevic/sofka/archive/refs/tags/v0.40.0.tar.gz"
  sha256 "4c15f6ad0efb7f157960cba3d034c1e5fc8643daa77805a4c0f82b50d2a3527f"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "6ed14f70b6f506e7c3e8020968ba30bb2034d2316755d6c2b616f629b953f39e"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d56c622c8aa8432881ee4243770de84e6d823f80c12d89028927eccfded41036"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "762e8348b92b90a6502324b3754111f29b7ac96f7bee05910059cf543c80f231"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9f50925bd1368a87bc0a8e43db1ca1951e94aafa80b1ad5385f88a1a69be4641"
    sha256 cellar: :any,                 arm64_linux:       "25d4d1594ca1504eb0fc665cd1e6065777c6495202f7534a97deb41bb1cab030"
    sha256 cellar: :any,                 x86_64_linux:      "e8bd456331da79a4fe7e3c1c1b6839223efe1024f6c02f543f480f19e4074675"
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

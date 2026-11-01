class Sofka < Formula
  desc "Kubernetes TUI, reimagined in Rust"
  homepage "https://github.com/nklmilojevic/sofka"
  url "https://github.com/nklmilojevic/sofka/archive/refs/tags/v0.34.0.tar.gz"
  sha256 "f1873049e7dc76ce3ef072ee8158a12f7fe2db6e3268e55e6da47a99172babaa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0f55feaae689730ef1821d1445f57a8307f1cb25d1a919125273f91d3a148b4c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d9673504c95e2c2108cc776f3f95b664025039304e8c9cc434bc34e2c9e45960"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e8a2a103fb2fda14acd304876f639b539b7ec21493b2f33f9d5591e8f73196b2"
    sha256 cellar: :any,                 arm64_linux:       "2d61e82a71b5959b9e55169dd598e4a106d2aa04b6133063bb7c4da7f0769768"
    sha256 cellar: :any,                 x86_64_linux:      "8a7fc8992db0918d3d2e099b420ff649840e1db7ce6b908e29495c53d48899a2"
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

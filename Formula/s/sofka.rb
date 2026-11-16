class Sofka < Formula
  desc "Kubernetes TUI, reimagined in Rust"
  homepage "https://github.com/nklmilojevic/sofka"
  url "https://github.com/nklmilojevic/sofka/archive/refs/tags/v0.37.0.tar.gz"
  sha256 "2fde24301fa99481d4012581255d7fdfacd76f2f7043602e178e5c08956eb8f2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1545ede0e645e336a256af5d1a970de2ac7878cb89c1d8caf187e281aee42857"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "df1659625ea338627db350778832b63005d80871df3d983e67036d2da319b549"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "33a9b7be01c6e7f022ec431a46eab95ed25051536b5621e5ce5cb95fcb0d0044"
    sha256 cellar: :any,                 arm64_linux:       "47f1f92b156d6a8811f85510d4e5af7d72f6b2c276ce25f26fd64ef26e2d97c7"
    sha256 cellar: :any,                 x86_64_linux:      "c71f15ec5f93ccef8e98f56ed1c34b0a1c272f9311020b15fc9d2e372a19935a"
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

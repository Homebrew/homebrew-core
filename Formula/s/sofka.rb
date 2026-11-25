class Sofka < Formula
  desc "Kubernetes TUI, reimagined in Rust"
  homepage "https://github.com/nklmilojevic/sofka"
  url "https://github.com/nklmilojevic/sofka/archive/refs/tags/v0.39.0.tar.gz"
  sha256 "f8400c9ca4fcf46acc4754745e60d136c77d4cf47947965ade24ec00da6a64e7"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "2a8914f10ebf7986f247fea3daf185b7ec4a959f83a67c952510c818b799f7b4"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "704b39bb032828cbcc58bf7f6e4fbb844e2499d437a317e383984e8cfb9916e7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2165ca118512cb7d5fd8e0da039409251d9923f13573fd99030886c6a122e194"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0a7e71bbb326bc98bb5c4ade9138446ec1a5a803ccf7c44975a4d55acedbda45"
    sha256 cellar: :any,                 arm64_linux:       "8bd976a6119fe4c84e2139e1204612e71fd8047232a182a38d63c894f6d6ebc6"
    sha256 cellar: :any,                 x86_64_linux:      "19129d6a50bedc32c2220e54027e513168930be5d43926f28010e5ed635d86cc"
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

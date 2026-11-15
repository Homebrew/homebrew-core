class Upmd < Formula
  desc "Run tasks and dependency-aware workflows from Markdown"
  homepage "https://github.com/rezigned/upmd"
  url "https://github.com/rezigned/upmd/archive/refs/tags/v0.2.7.tar.gz"
  sha256 "dc662fc5fe25f6a0a4a7fb591d7271dcd67b2728b7acd74c5e2e549e744a6516"
  license "MIT"
  head "https://github.com/rezigned/upmd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "04495f0ad1be309a62e26d5c28a625d3ebdfcd3e007adb8b8a2277d252eef0bb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "02cdda332a4007c2acdf655fea84e9dfeafa6f2ef06430c666c9ddb2ea1b9829"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8070a19cb87ec49553231efd003b896779a089cfebe837d344bd5a8972fc74b2"
    sha256 cellar: :any,                 arm64_linux:       "4155f6bfc8a0878dc23f6b94c180d80948aa935a0d37fa171b94155eae6e59b3"
    sha256 cellar: :any,                 x86_64_linux:      "f7e3e6ccafb735104575732128a6a8e024cb0d3caecbd450b5086f32f8a22709"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/upmd --version")
    (testpath/"up.md").write <<~MARKDOWN
      # Offline task

      ```bash
      printf 'Homebrew task completed\\n'
      ```
    MARKDOWN
    output = shell_output("#{bin}/upmd --ci --all #{testpath}/up.md")
    assert_match "Homebrew task completed", output
  end
end

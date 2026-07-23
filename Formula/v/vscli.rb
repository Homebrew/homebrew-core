class Vscli < Formula
  desc "CLI/TUI that launches VSCode projects, with a focus on dev containers"
  homepage "https://github.com/michidk/vscli"
  url "https://github.com/michidk/vscli/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "c78fe7e92958cd76fbc3cd4a61112e96f770af64fe03060337a60f26609a6bc2"
  license "MIT"
  head "https://github.com/michidk/vscli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5e9585fcf6d4dde321dfcc07c8329add292601c34fd9c33a223fc862860d7f3c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44b6229f606c9974ef1eb7fd224ddce0f2d92fd94dac68c2afa0e754556117bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12aeac733cddc8e0b05ddf7341d224abc7fa625f82953d8dbbd571e7a97b7cf6"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae26b40677a6d1e3e2547afc5bbc8f21eed6e0153632571b3d963a371f4e2716"
    sha256 cellar: :any,                 arm64_linux:   "29586583aef04bdb0e1a94f714389a25bde1e01d73cb59f2f1256b8643af6669"
    sha256 cellar: :any,                 x86_64_linux:  "20a7a3fb39ea62b0c8547b7d9a1000e380e6129f32f4888bd7b6dd1f593ab726"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vscli --version")

    output = shell_output("#{bin}/vscli open --dry-run 2>&1", 1)
    assert_match "No dev container found, opening on host system with Visual Studio Code...", output
  end
end

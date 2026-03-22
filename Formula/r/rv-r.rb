class RvR < Formula
  desc "Declarative R package manager"
  homepage "https://a2-ai.github.io/rv-docs/"
  url "https://github.com/A2-ai/rv/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "879384784848c863e25e687c03554e103a0957dab6a870b4b57708be29e269a7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d3341d2e33785090a0f8160f59b7890232dff56377d0467901589d04dcaf1b3c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2add9a296120c6944ce6e498e468c01f55f35fc2ba2d2a1192df3a86d886f667"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4291e5b3d2a926f6f752c762f453d8004baaf609e469ec621c6e4d3fc7fcc5a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b4e3ea73a37fc06b42b912a2715024e1e892a4cd7ae08ed6de051b54a2509a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e13a8d0b95eaec08c3d1fe1cf5ad709a1cd4242ecb4741cafbb2551e2a52150c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0313365b4550e3be68c79c79370ef2740f030bc177f8da46782064584864f2f4"
  end

  depends_on "rust" => :build
  depends_on "r" => :test

  conflicts_with "rv", because: "both install `rv` binary"

  def install
    system "cargo", "install", *std_cargo_args(features: "cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rv --version")
    system bin/"rv", "init"
    assert_path_exists "rproject.toml"
  end
end

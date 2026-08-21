class Serpl < Formula
  desc "Simple terminal UI for search and replace"
  homepage "https://github.com/yassinebridi/serpl"
  url "https://github.com/yassinebridi/serpl/archive/refs/tags/0.3.6.tar.gz"
  sha256 "d794e020e3e6535ac2c0cee3613ffb9122e4df7a47d4e5c466e8b35e59e08312"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "691d73b56ebd15a6b95cfb0290639a2b708d58cb4dcbd896689fed79f3f3f2ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8cc7b7dad763673aae27fc5dba3c4a95bd6c170ce52e497111110dfa374a3959"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88bf27db3054865d754aeb1ef375dc4251562bcbba7c1141130309603ef67169"
    sha256 cellar: :any_skip_relocation, sonoma:        "69998a4447ab18444ee915ddf89869dcf47810b94aa33bc84ae54f722b98f979"
    sha256 cellar: :any,                 arm64_linux:   "b6b72ecbe27cdb0daac5649d0a4d350f3eb3e8785a790b1363c83e7bcf6f1fee"
    sha256 cellar: :any,                 x86_64_linux:  "55f90b322c27459a3e3d113b1a8f6bed4d34df6f8cca622b68039c72c4c34849"
  end

  depends_on "rust" => :build
  depends_on "ripgrep"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/serpl --version")

    assert_match "a value is required for '--project-root <PATH>' but none was supplied",
      shell_output("#{bin}/serpl --project-root 2>&1", 2)
  end
end

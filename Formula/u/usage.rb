class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://github.com/jdx/usage/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "8ee6a18e73f04c85d482a173972f280674eb2bc68bfd6d183052646dc2cab7eb"
  license "MIT"
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9e16c6dd4481b4ca5209b2508715e05a48f771f1759437e5cd8c8972aaf97d4d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f90f8a7b7a36d4a29e454cbfa6e154990f98c3b78dc3ca5e768a93f31a82aa51"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55e6fd898aaed6aa675235c70c55e57a2587cdebc64ba41cde5d7f6fa1a86b07"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc27126b7d953d1882f1d2ef6b9b2bbac56afd7501e0ef01eadf8e5b29dda679"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6954790d088cbb2bafbf81b1bf8e0fd708a08a4a3df183f685efc75fa95d76f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c7bd43723b8073e99ff2af42de1679f2e2b8b6c88994179854ddd70873a473f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
    generate_completions_from_executable(bin/"usage", "--completions")
  end

  test do
    assert_match "usage-cli", shell_output("#{bin}/usage --version").chomp
    assert_equal "--foo", shell_output("#{bin}/usage complete-word --spec 'flag \"--foo\"' -").chomp
  end
end

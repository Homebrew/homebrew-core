class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://github.com/charliermarsh/ruff"
  url "https://github.com/charliermarsh/ruff/archive/refs/tags/v0.0.275.tar.gz"
  sha256 "46df7bc61264292c6655dcaf6013b9d5f7e60589beafe4af6225e536e21a85fa"
  license "MIT"
  head "https://github.com/charliermarsh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b0a2737db70c51f7453938c4b609d41a4a80010490763fccf1355fe48641e8a6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c6ff94116a9134de2990c549cf54e165b03859b8be97f85c0463f168a891d5a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "77b1e1a36a47a46263e9c6627bcbac253edea4e3b75cde0cb9db8b9a0d5cf005"
    sha256 cellar: :any_skip_relocation, ventura:        "503759f18aa4458f4e933daf752e39d89befd1678b002bf94bb711b6cdca1471"
    sha256 cellar: :any_skip_relocation, monterey:       "24f0067d8fa54479031e2bbbb59cfd52b1f831ea7a298e7504dc592b34945509"
    sha256 cellar: :any_skip_relocation, big_sur:        "772562914554c1d420aaf47ec687020c3af39324a4b3c4951f074f73c849222f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c26409f8cd31ea4cf05253802e440d5e7c6de1d568776cb98798170e397205e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "crates/ruff_cli")
    generate_completions_from_executable(bin/"ruff", "generate-shell-completion")
  end

  test do
    (testpath/"test.py").write <<~EOS
      import os
    EOS

    assert_match "`os` imported but unused", shell_output("#{bin}/ruff --quiet #{testpath}/test.py", 1)
  end
end

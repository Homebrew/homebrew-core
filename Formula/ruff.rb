class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://github.com/charliermarsh/ruff"
  url "https://github.com/charliermarsh/ruff/archive/refs/tags/v0.0.259.tar.gz"
  sha256 "0b4dc24b447380706afe980de62234d596e0b5f66f8d60e9fe71a637f031d939"
  license "MIT"
  head "https://github.com/charliermarsh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2fe0ebf1c06a5b79ef1c0444c9a3b4d9f3987777dc21f03389486f431666b753"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f60d63b5ed7d429abdbf062b8179bfb7edbec589ff04757e816bdd7b29507770"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c2450c7b01c9dbdfb5afdd3f6619e79ec66366c6fa8f7669a41f594490586526"
    sha256 cellar: :any_skip_relocation, ventura:        "3b0b2585c7f3156d011c19d9eb0ecad931e9e275f0f7fed823147b2c8b2f95fc"
    sha256 cellar: :any_skip_relocation, monterey:       "c30f33674e3ce731d0ede3a0dac5150f13d4be035909f1f39f90911948c151ba"
    sha256 cellar: :any_skip_relocation, big_sur:        "2bfc80a834c93d132d2dd51b1135dd949c80af259fe5745396c136593a25e62d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b196ff1877769e6f5dc5d245a44314da1c81d3601eb3088fd019b8a117b825b2"
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

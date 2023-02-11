class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://github.com/charliermarsh/ruff"
  # ruff should only be updated every 5 releases on multiples of 5
  url "https://github.com/charliermarsh/ruff/archive/refs/tags/v0.0.245.tar.gz"
  sha256 "beedf7cf9ea0d128aabee957a4293e4f9241ba3fe5de5a79762028ea1b6a7727"
  license "MIT"
  head "https://github.com/charliermarsh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7467dd4ded9415872865ebd50cde62bae457d4b90098d4ecfed77f8f72969e4c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3bd4d71a1b70e53b1c48d1a4e207887c7e86a4dc67bc05e519b498d7e1f12fdb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c22de6dd25e0034b843e7b8fe7352266167fdb0dbe636a275fd45c4ce076b027"
    sha256 cellar: :any_skip_relocation, ventura:        "fb33553e27ee7ec29ad020d82d654600406cea9737905cf2c0b57e6312708633"
    sha256 cellar: :any_skip_relocation, monterey:       "ca7cb5462811b90d3c4bdd57be04b2ed93d936365416cc7e852919e710bdb84d"
    sha256 cellar: :any_skip_relocation, big_sur:        "c8e8ca7c5e9d99398a29872b7d1e3ef3e52b4e288b6bed566b41f4bf9dc08109"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "026cef36f9cb2f4d80577e05a537d726ca64d0867769356e110353b599a4a64e"
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

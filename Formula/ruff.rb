class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://github.com/charliermarsh/ruff"
  # ruff should only be updated every 5 releases on multiples of 5
  url "https://github.com/charliermarsh/ruff/archive/refs/tags/v0.0.255.tar.gz"
  sha256 "2a9b4e1f9d3876162d53e2a853c0299068dd56eddd2e0cbaa44a8f2fb1788a35"
  license "MIT"
  head "https://github.com/charliermarsh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c4e8dfea764e40644abe58535a22b19c1a930be9cdb16a6466e5f4c1bf57ad9b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9032c6f61da170a215b7758cb8a1b3f5b15fc2e137fc30474c99998c81b6cb48"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "023010a9041d437e7285f64d6032f31525cc2262ce3958516c76c92c0396d5e4"
    sha256 cellar: :any_skip_relocation, ventura:        "a9df80ac4220e2d959f54481b0ffe4a91633962e69c63929094e44491f266796"
    sha256 cellar: :any_skip_relocation, monterey:       "7a57d146b790cb79482846dc79dd5e11425267e723414ce0a8b4df3d0ee406a5"
    sha256 cellar: :any_skip_relocation, big_sur:        "033463f1d374fb42841cbbb297f6fdfde78f596de6c8be4146da161a9dd9c4c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afa80270021bedec93da75a5be8891b96102aab272a13f9e288285755ea19b1b"
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

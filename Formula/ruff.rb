class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://github.com/charliermarsh/ruff"
  url "https://github.com/charliermarsh/ruff/archive/refs/tags/v0.0.261.tar.gz"
  sha256 "77ee27c36e047b16f764cf6666a359f19b8428702a06cb424b0f1595f5e35b9c"
  license "MIT"
  head "https://github.com/charliermarsh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8310eb576cada1b5b4d38dbf94999070c099670cdfb604b8b67fa16c9a124e72"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a22a5903c82f2a9666b5a92fb0e29264fa179e09f714195965751c24bd9f9017"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6aad7b7e18b6252da76bb9488b0377d06dd8a4a25e91cb124aaba9c7f6d78893"
    sha256 cellar: :any_skip_relocation, ventura:        "64d49d459208c338b4a196318de6c30bcda982b7a82480aa19400b6903c3d6ba"
    sha256 cellar: :any_skip_relocation, monterey:       "093af7ae74d1e709b52c6907e7167b82838ded15efea2c06a6d729ee08d808e6"
    sha256 cellar: :any_skip_relocation, big_sur:        "6f998109e521817e6dd9cadeef1bffaa35d7fd0bd05e5b3e87cc8c9db014c028"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad06f3c62459a4b43b8c1d3586fad7606bba8f70893ba96468c86c69a982d196"
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

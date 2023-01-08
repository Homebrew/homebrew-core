class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://github.com/charliermarsh/ruff"
  # ruff should only be updated every 5 releases on multiples of 5
  url "https://github.com/charliermarsh/ruff/archive/refs/tags/v0.0.215.tar.gz"
  sha256 "a121ab12f1f8800bac23a6deb20ad642fd610988cf066c2425883a434667eb8c"
  license "MIT"
  head "https://github.com/charliermarsh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cac51b2ee4c736d4c49fa981e809ec4e18e4c421a913ca7b59f12ed723e0fbaf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "949174270b697f9da3fe62e0feee39e19711d4a16b6ef1ab3e20e1ce99364fd7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1777148ab3c1ebcc7ccf6d843c7c7654aa4dc6a952ecc39909c4a3ec0d524354"
    sha256 cellar: :any_skip_relocation, ventura:        "f97977b0120a6f58a6d466577ee03618c8b28e7c80f830332632588e1773d5c9"
    sha256 cellar: :any_skip_relocation, monterey:       "b5fd5f0a51f63ca7383296e89c7f6fdc7e43f7b55f3b2721a10d60f39a9bb937"
    sha256 cellar: :any_skip_relocation, big_sur:        "4b223400fbac798c7b37950a620e0b2e46718f8c53c7e5b28ddf59dff2e8294e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "648531ce746bfa21ff74674edff1b08d4db240743dfe09e835667e6e56d20921"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args
    bin.install "target/release/ruff" => "ruff"
    generate_completions_from_executable(bin/"ruff", ".", shell_parameter_format: "--generate-shell-completion=")
  end

  test do
    (testpath/"test.py").write <<~EOS
      import os
    EOS

    assert_match "`os` imported but unused", shell_output("#{bin}/ruff --quiet #{testpath}/test.py", 1)
  end
end

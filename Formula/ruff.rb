class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://github.com/charliermarsh/ruff"
  url "https://github.com/charliermarsh/ruff/archive/refs/tags/v0.0.179.tar.gz"
  sha256 "5bc498be4419e4a8fe1c1421ee2e335ab32581b66cc4c071f088786a39be2a00"
  license "MIT"
  head "https://github.com/charliermarsh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df0f6aa38b1c25d859a291023ecdefa1b98757e26bc07b2f8975fb4d25a25d17"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42f1d188a284dd7580cfac3c34890e19e4496e14e34d5f164e6733b86a420968"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fdc7912c84cf8244e0eca16f1da131793b59cc8aae6b7c3eb24b74e606f2cadb"
    sha256 cellar: :any_skip_relocation, ventura:        "cbfa78a0deb5778e19199622621734886fb0a3616fe080faac0bfdc5bde378e2"
    sha256 cellar: :any_skip_relocation, monterey:       "983814860330f2b3ec04aa97c5262caa69eb1a9464b9690eacf7d23259101a5a"
    sha256 cellar: :any_skip_relocation, big_sur:        "908ca47364513d7c535801f5caf3bcfaf36993837b72881d4f3a060de65e497b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7cac68dfd1c14d1aadb1ae01bb9e5852665f58d3b13eb010639db78988196bf"
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

class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://github.com/charliermarsh/ruff"
  url "https://github.com/charliermarsh/ruff/archive/refs/tags/v0.0.205.tar.gz"
  sha256 "cdf64d2020a3695404f35fc7bd6ce53371ba6103e2c5522584af4bd8ce305f6b"
  license "MIT"
  head "https://github.com/charliermarsh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae534452d5518991a9a30c52e5309c3ce42dde0cd0e3f73c87dfce9443e3e7e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1509addfd26648092fd446da2515a4a1ea3d6e8775b19bfc263589ebd764973f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0f620e47b3b68e29e44fe3cb4169d036dd614a5fbfd420f6237661e815ff5498"
    sha256 cellar: :any_skip_relocation, ventura:        "278174983ecab64ea5aa82f0cfe9330c469726c6a6e26ebaffc43e4d009c2d30"
    sha256 cellar: :any_skip_relocation, monterey:       "bf0cf33ceb0a2659201e4d14f6d48d267ad2f9d1264e92e1472cd0a92cdeec7e"
    sha256 cellar: :any_skip_relocation, big_sur:        "9d3679fe869b0d5ee3a65ebaccfb2cd1044dc7871e5d92d75799e358a1e6c1f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62bc5572837761b9fffd70764316dd984024d9383f8c8f07ae01b6750afb510f"
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

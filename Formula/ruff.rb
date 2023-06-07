class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://github.com/charliermarsh/ruff"
  url "https://github.com/charliermarsh/ruff/archive/refs/tags/v0.0.270.tar.gz"
  sha256 "5b2b9ae2eaf27f2c95233e5fe3771ed48923a001d792e0abcc212b9a37644cd1"
  license "MIT"
  head "https://github.com/charliermarsh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "36e9e0d2625d77126f920bf11573315f1bfacf560311816a4338a649158ec7c6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "167efa1f2ed0f32c3313e81e146a415bc3c8bd3f6cec356d11c26e5faf94d18c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "28771b8d615e7fab88c59df5574fefc0bd53bc5c154c94cb17ddb4c9a6071a90"
    sha256 cellar: :any_skip_relocation, ventura:        "c140ea149e017ef6922402203194fce37375d2e1305b2639e51cf626f6ba1f34"
    sha256 cellar: :any_skip_relocation, monterey:       "92fe55196fbc52c32ca472d59a62dcb1f5180fb733848578e406254a44c3f237"
    sha256 cellar: :any_skip_relocation, big_sur:        "fa1e78bfe4ec13239fb458e124269a6d73800db2c85a5e030148991873da450d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1234711acb2955cb647e149be9c5b3068e4daa22957997b4be4ed2da896f881b"
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

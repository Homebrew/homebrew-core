class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://github.com/charliermarsh/ruff"
  url "https://github.com/charliermarsh/ruff/archive/refs/tags/v0.0.198.tar.gz"
  sha256 "74e7d7a82a1d3ef17a9c7d9a2adc7182a96877cbf5b96bad3256cd8e675e42ce"
  license "MIT"
  head "https://github.com/charliermarsh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3a546aa92469273b1d128df7274c6260de315dd7f8ac88551fb5f6cbe9662e2b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2adbfb6901c79454faa170eb0b87e59d2fb3469f788d2f09ec557b5391a4761d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "99eec81bed5b8a751e2d6ac05acdd6420aa9fa9c358a9e6db8edd35abbc86d8c"
    sha256 cellar: :any_skip_relocation, ventura:        "abb73139ded56595f88d6a10d3374100f26e0c10d6bcb6fb8f667b9fc9e2f1c1"
    sha256 cellar: :any_skip_relocation, monterey:       "cfee23c3e236c067f8d02f610c66a8bc7630993623e412e1868a428ceed3f107"
    sha256 cellar: :any_skip_relocation, big_sur:        "31c3df5e743cf1c89923ecd4dbf47d2c52905756cb6cf6a0de16d2e8905c98fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d03866ec2fa9caf8bcffa0e863acffd1c54603a6be2ffff93845d3856908708"
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

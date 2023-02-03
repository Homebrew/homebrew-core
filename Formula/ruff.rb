class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://github.com/charliermarsh/ruff"
  # ruff should only be updated every 5 releases on multiples of 5
  url "https://github.com/charliermarsh/ruff/archive/refs/tags/v0.0.240.tar.gz"
  sha256 "6a38b7711a41010d34285c88e66bb0777fde2e15427213636a81485782eef83c"
  license "MIT"
  head "https://github.com/charliermarsh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ac080b1145b1da7364ef2b1bba9ef468d99d1e43c1d806b6674533391e9053b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "21828e15e16bca1ce65e71a438de16e21e13a859c52e2fc73b831019801e1168"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fe87c33b038b1b4c2c96c19c73d277d828383d5bd5f6f203e57a4cfef5e81464"
    sha256 cellar: :any_skip_relocation, ventura:        "318379dbf9083969bfc3723538e6179f4b1078b07e2788ae605e2f1714c7024f"
    sha256 cellar: :any_skip_relocation, monterey:       "c78aa0369f309610429d306f4bb4c7c2014979d77700d6b49a6e9757d69b3a3c"
    sha256 cellar: :any_skip_relocation, big_sur:        "9a2e042f961ef1c3c7af0231ba5c55c9e231237da15d6439533c4ec3c7f1e724"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "469505592eb755bb2715adc3601a09190261048bbb28583418a5dc9fd1c84a39"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "ruff_cli")
    bin.install "target/release/ruff" => "ruff"
    generate_completions_from_executable(bin/"ruff", "--generate-shell-completion")
  end

  test do
    (testpath/"test.py").write <<~EOS
      import os
    EOS

    assert_match "`os` imported but unused", shell_output("#{bin}/ruff --quiet #{testpath}/test.py", 1)
  end
end

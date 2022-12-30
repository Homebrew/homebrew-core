class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://github.com/charliermarsh/ruff"
  url "https://github.com/charliermarsh/ruff/archive/refs/tags/v0.0.200.tar.gz"
  sha256 "db6437c197e1e1700fed6d5b92fcf5a2d151a5b5c478f5211528fdbde89107e3"
  license "MIT"
  head "https://github.com/charliermarsh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "23dc2aa5a3e6c4454be1c899cd5d188703763eab731f5c20824871107393925a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c54195f4ca7a9651253acfe5f1d80bf7d83fe77ffd5f8c95f13c3d3d2281602"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "70eb16a59b58280234916ceaa7e23c2cb81691422e2c11920b74093540e42b5a"
    sha256 cellar: :any_skip_relocation, ventura:        "6f876a6b51688cefd56424199ee23f8d8259c1e473d59004011f389e7f5b69bb"
    sha256 cellar: :any_skip_relocation, monterey:       "78dc2b49ac8f96f15aa0b107dcf27d2c49380c453ad9ca06b880d8918ba20f6c"
    sha256 cellar: :any_skip_relocation, big_sur:        "839b285cf00bb2d1e8ea9cf995f8250f4cffbe2aece82576f0551395781186d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "177f42dfc8e85f86f921f769c24a584cd618f43a227d8b77b4c5fc4a784bfe16"
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

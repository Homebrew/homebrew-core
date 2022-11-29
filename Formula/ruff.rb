class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://github.com/charliermarsh/ruff"
  url "https://github.com/charliermarsh/ruff/archive/refs/tags/v0.0.144.tar.gz"
  sha256 "770e443be95b239230a0137e266345f03096e23b9cce3cc1a1ff7a067503b1e7"
  license "MIT"
  head "https://github.com/charliermarsh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cde0f4392a143655ce91491b045af2aef6f04469c2e2fd07bef016deff3de16b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "485e29a5c62744f081680b2917d42f92def10fdfb924d479893612a75a0b5b59"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "22b1654166dc4da42fd2addd0e24ae05c488310f6eec32093111d95bdd5ee738"
    sha256 cellar: :any_skip_relocation, ventura:        "ed082327dd5b9a5414aff74aef692b27b5e50c8e2a3cea4b61a95adff353a6f6"
    sha256 cellar: :any_skip_relocation, monterey:       "9e66c117d81552799eb00cd677467a43d909c49658bc5cbfa09e74f3f83b55b3"
    sha256 cellar: :any_skip_relocation, big_sur:        "05a42ce406847b7516a818e4022f24930c5e67ec858b4fa390c9e0cf65360bb1"
    sha256 cellar: :any_skip_relocation, catalina:       "8d399eb85329b5cf0dabc850511cab27b4f43498a677ea5e9db59a15107a58d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02c4d13938a00678060f2204bc81daf26be9a6cb3b40bf034b4b8440e3a8a54c"
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
    expected = <<~EOS
      test.py:1:1: F401 `os` imported but unused
    EOS
    assert_equal expected, shell_output("#{bin}/ruff --exit-zero --quiet #{testpath}/test.py")
  end
end

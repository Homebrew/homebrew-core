class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://github.com/charliermarsh/ruff"
  url "https://github.com/charliermarsh/ruff/archive/refs/tags/v0.0.165.tar.gz"
  sha256 "3546323f4d460f311269c5244d290ef46a37ceb133ee9a8cb3759df01ea5da7b"
  license "MIT"
  head "https://github.com/charliermarsh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b45184e4c4a3ef3501f1366957384a4291590bc0d4c15b355c1941a4ef98faf8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d61a2ff8047edf3b274a756b46836f9f5895ef301d401a3c2e62bbf420a619b6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fb716522838cc578399057a3b65f58e50b3974888ac8e4a504da2eb47a170a03"
    sha256 cellar: :any_skip_relocation, ventura:        "b2dc21646b1f05d7cdfc12b8cf1090edb7343fd1515ee8066cbf6e8228c587ab"
    sha256 cellar: :any_skip_relocation, monterey:       "f9ac28b23aaa16a0488778ce6ae26b562a346f9cdc16f999f61dbe5dbba7d7bf"
    sha256 cellar: :any_skip_relocation, big_sur:        "e495848c77712d377e6485cf799cf29e56d34abf6ce7abb4d0130648a8f4aadd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1487f475794ac9f282afd91987fe1db3b1ae08fe98dbfd33ce5326706488c379"
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

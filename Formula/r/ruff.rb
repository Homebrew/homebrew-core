class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://beta.ruff.rs/"
  url "https://github.com/astral-sh/ruff/archive/refs/tags/v0.0.292.tar.gz"
  sha256 "901d418e195e035fe38641c22400df09ef4712ff4ef1dd872951323eb0e0b59d"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "16f8444d8fbbeac3784fa42626dcd6a0fa343cbc8e0b5b681751aee8152f60c4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "87adcb9de1c1347f2ab057a4a7ec4f1b999b6e807c8ec4137b9cfd322cf1d16d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7e6f267ecb8dc1048d2a82c3f6f781d0c40f025de6d151c4018ff808e2beb7c"
    sha256 cellar: :any_skip_relocation, sonoma:         "5a7eb9149b0da30238abcab9f43d132265be60b8d45e649abe2e565148c9bcce"
    sha256 cellar: :any_skip_relocation, ventura:        "11bc1c228a48d9a994e1ee699fcd800b424b900b88107fb2a5809bb835e74bd2"
    sha256 cellar: :any_skip_relocation, monterey:       "706dda47c598633d998d096e171dfef870ca5aae0025d57e330a4dd1730c36fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87afe028f0ab26e1903fceb2bbefe9dde8cd68f99043b12c29401b6f43cbc176"
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

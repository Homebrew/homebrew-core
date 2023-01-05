class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://github.com/charliermarsh/ruff"
  url "https://github.com/charliermarsh/ruff/archive/refs/tags/v0.0.211.tar.gz"
  sha256 "2b39199cdead25b68727724151003edc43efb9fca327ab634926b14d0a6acba0"
  license "MIT"
  head "https://github.com/charliermarsh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e37b10fc644e6462def69e031912434d02a36184fbc7c3ea1c3229d42a2f2912"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7323d63a4fe811de630b5be08ca821c9f7cec5b1fff5c966cf0d5b0cc8b4bd6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1b1a6b1de658524b80bc442b419d4b9cac2e8dd04216b72f5c85c3471076cb34"
    sha256 cellar: :any_skip_relocation, ventura:        "1254d585b9f1b2be7ebe6c612c5faf501708dc6bd04dc4c6959fc2da920d7268"
    sha256 cellar: :any_skip_relocation, monterey:       "5e4e5669f409949f8a9db1a16f3baf6410d119d3e43d696e70b57447147af925"
    sha256 cellar: :any_skip_relocation, big_sur:        "5d96f68bb4f0e68bfffc73b03105ab94274ad70a826fce1daaf46152fa332844"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "196c3f3164cd2312d57c51955d9525ddf38795f347430522b3110448d9b99513"
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

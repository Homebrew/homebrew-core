class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://github.com/charliermarsh/ruff"
  url "https://github.com/charliermarsh/ruff/archive/refs/tags/v0.0.203.tar.gz"
  sha256 "9ea96e221b10d4e005e73d884a14eabd8cac398f42ac474eacee4a81449f6672"
  license "MIT"
  head "https://github.com/charliermarsh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f37a9b11477b0b98b81bc1696e0497b9523d01a1ac01b4ca490737546d5c4b69"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9986a6041a022aff993a1349ad22fdedd8b9b4b7a061a7db0889771e19daf9db"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6de69871b01ef3ee2523919f0331d1171e917ea7d7a0278e3386faeb84e25b8a"
    sha256 cellar: :any_skip_relocation, ventura:        "38ffd48e755dbc4dc4265e26c7a291ec41ad8d27ecbfd0b7a02a7dbc7a7cacdb"
    sha256 cellar: :any_skip_relocation, monterey:       "31cc7138812827b27afe6db0ae9f10bfbc88c610d545706d2720fbc545700a60"
    sha256 cellar: :any_skip_relocation, big_sur:        "f72603eca0a610b5439af7349a8cbd4671189a12e4bcca205db4502accf81862"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9cf731b5c5ff81f2185ba45d87e16fc832756676a60a695210c3c1797f3c75c8"
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

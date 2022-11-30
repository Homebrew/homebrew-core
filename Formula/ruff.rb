class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://github.com/charliermarsh/ruff"
  url "https://github.com/charliermarsh/ruff/archive/refs/tags/v0.0.146.tar.gz"
  sha256 "b4ea6ac91a5d75c1ac9184af188f274fd08de21dd467d19ed057dbfed8288d30"
  license "MIT"
  head "https://github.com/charliermarsh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c9b6301745f2e292a8c7b69656554661f0c9bca1d5bb4b3c273d3de9977ef17e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ae37e8f99cc771e8b05866532d1e24fb46529e7719037a964d416f1e457194b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8490bb4e00bc7bee65d8a83465d68353ed375d0c45f4722d16f1c5e2cd2f6675"
    sha256 cellar: :any_skip_relocation, ventura:        "89421efd6a57a31a8f47d22afdf6ad4111a7ccd4bb0590c37bd13cae51876227"
    sha256 cellar: :any_skip_relocation, monterey:       "2ec2421abafe6b184bd4fb1f8f2764ac74e3e3905216765e9c59ec55827aad6b"
    sha256 cellar: :any_skip_relocation, big_sur:        "3b87be0c4669496b153d49d2e892b950a5a167b962cac910c90ea16b3e5488f6"
    sha256 cellar: :any_skip_relocation, catalina:       "443ae6c3ab85b719386c4d05156475500bf488cc00caaf88c7465204c0efedb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cea4b3c08535936979bd3d4e8d836d27291187d4777c31865963538b49310c00"
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

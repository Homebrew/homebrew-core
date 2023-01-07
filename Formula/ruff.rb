class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://github.com/charliermarsh/ruff"
  url "https://github.com/charliermarsh/ruff/archive/refs/tags/v0.0.213.tar.gz"
  sha256 "868744081c26775923986768c546d0f9e14c8e961fff6ef90557dd39e3983e7f"
  license "MIT"
  head "https://github.com/charliermarsh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf914dee37c1c543c8d7fefd79d463febba443948c9cdc2fba4ae19542d99aec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93af52fa3752787abdde077fd6d183ff0d5a66102360a3c4c6ba6ce64b9800ed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "60a1c24cfc0ed7d9e58fc95b4970e057e1fd5f22a19c96a9fb3e82772175bbf1"
    sha256 cellar: :any_skip_relocation, ventura:        "86bd6e6491faa83c58cda7ca931cccb9e5f9467179d8a1f40d325a53c68e05d3"
    sha256 cellar: :any_skip_relocation, monterey:       "c87f9fa3f2206f8e51cbe535e767299947f86f9f797d293541670f1822a3cf0a"
    sha256 cellar: :any_skip_relocation, big_sur:        "e5a23b979dbdff3d3127a0ba2bc6285e1d8ceadfbce5804f2c210761999cc19b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "957b0e14ad4e17e60ea38d925988027058636340a72b971cec10283d057a1f33"
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

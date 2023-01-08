class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://github.com/charliermarsh/ruff"
  url "https://github.com/charliermarsh/ruff/archive/refs/tags/v0.0.215.tar.gz"
  sha256 "a121ab12f1f8800bac23a6deb20ad642fd610988cf066c2425883a434667eb8c"
  license "MIT"
  head "https://github.com/charliermarsh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "987eeb35830ee1c04b83ca929a320da6de0ee6a3e7f90a66e1167b61bb70a67b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8c77cbc66344fc12f72265e21ea8cf5464aa60a7eacefb24287b6f3ef96d4ae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9603b16a450bd1d45eaa7f97aa7db6e5c43418b8bcaa2ee5339e4494ed1ffc96"
    sha256 cellar: :any_skip_relocation, ventura:        "65a478488a84f4b10bf0d645e814b69b78524f8051245561a7769a31988f30ba"
    sha256 cellar: :any_skip_relocation, monterey:       "251ffb981a235c013a9240c97364a5afe1809b601bed29891aeff7a99583f5d4"
    sha256 cellar: :any_skip_relocation, big_sur:        "a3faef7b3198c89721b4b8598de23c7607239fb9664a9107de472f46bd4a93b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ebe5a7c822d399f475deefeb0fb860409e0ec29deea5c8e4263f2259e23fc17f"
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

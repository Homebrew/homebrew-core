class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://beta.ruff.rs/"
  url "https://github.com/astral-sh/ruff/archive/refs/tags/v0.0.291.tar.gz"
  sha256 "b7358133498febbfdc0d119de4dd9c7659b866c7ab8b65e1dcef387e1e2766dc"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "40473301d9041fd25fa7babbc16eac05db277207abe5c4aa1b44de0535eeed5e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5d1f9ac903352607cf8eb92a873e3fe8ade139dd9b05a5a1786dd4ca5131ff29"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c0c0624e2faa5323701c0cfc2568034411eead297e1355f48217957692c2b7d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "97a54bff6132037761d5e2dbd74160744963a22e855274cd3397d5f51f781b59"
    sha256 cellar: :any_skip_relocation, sonoma:         "27f2c4e96bd593717e17c807cc516cbe1481a29e747da15529a08ff57d30a420"
    sha256 cellar: :any_skip_relocation, ventura:        "31f2c6e56004024b093b12270f48eeb19218b47a64dec7424134989d33988d6b"
    sha256 cellar: :any_skip_relocation, monterey:       "c6b0b8c925a309c81eb6e9fc929985f2fb1fc8e9a5f4145e2a6931913082a504"
    sha256 cellar: :any_skip_relocation, big_sur:        "77955ff36ea5ae8a20278bd9608de4aff319bc626f3358d4f937fef7c13c2016"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7911e611231fdf3ad1968a5565008ed23c06bc1998c1a92054de7e2f9e9c4b85"
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

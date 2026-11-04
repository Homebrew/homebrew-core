class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/d0/95/25b7533185c74ba38d859e3477e74cd98546f59a4ae5cd3962d11c3c6bdb/ty-0.0.96.tar.gz"
  sha256 "f3026ef87a5ee1bd0687100c775af75a53289afe8e35b6e85bc3d1ce7d2f98cb"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "dfd073bdcb49faf6e96d39b1a34fd88268586e742bb7f8cb2cf42fa1b2065ecf"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "dc5359185bf20a27630c02c66220bc64555812cbeee793f3b840768cd9f1e3ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "287b3a1dbe45c0678408154d0e129aff1154f5d02de1a71dbeaaebe322fe1e41"
    sha256 cellar: :any,                 arm64_linux:       "5f6b21966291483ed36c866bf543acfc734268a1dd0228832a64b3666365d6bd"
    sha256 cellar: :any,                 x86_64_linux:      "f9b5766289f9bcdd75bc720e3c3cc1748c86f9db4f36100d588cbe0873db2a55"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    # The sdist prunes some `ruff` workspace members but ships the full repo
    # Cargo.lock, so `cargo fetch --locked` would refuse to shrink it.
    system "cargo", "fetch", "--target", "host-tuple", "--manifest-path", "ruff/Cargo.toml"
  end

  def install
    ENV["TY_COMMIT_SHORT_HASH"] = tap.user
    ENV["TY_COMMIT_DATE"] = time.strftime("%F")
    system "cargo", "install", *std_cargo_args(path: "ruff/crates/ty")
    generate_completions_from_executable(bin/"ty", "generate-shell-completion")
  end

  test do
    assert_match version.major_minor_patch.to_s, shell_output("#{bin}/ty --version")

    (testpath/"bad.py").write <<~PYTHON
      def f(x: int) -> str:
          return x
    PYTHON

    output = shell_output("#{bin}/ty check #{testpath} 2>&1", 1)
    assert_match "error[invalid-return-type]: Return type does not match returned value", output
  end
end

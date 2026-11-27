class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/78/d9/243dc6db0c9eb188067c5cbcc5fb4bb3b3c4e8b83fb40ee387d946b10420/ty-0.0.111.tar.gz"
  sha256 "9bab00d6c9129d28e28d81fbdf8e70b8a3522c41dc8f0ca8307eb802479a2c37"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    manifest_sha256 "aa621811d6fc46b5737dca2151acdf4d1d729fea38e761a09b8a37df6061bd8d"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "14fc221b1cfb1098c0e9fb182f3e48be7466fcf716d17846fc92fb7fa694b4f7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "74a43e922494ae5d670deb1830a84d1f674730897a4ba39d501292d383099db4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c92cf577a50638750903c36fca6e6b984ea872dbcee94b8ad4ec047f23e405f8"
    sha256 cellar: :any,                 arm64_linux:       "ff172602cba72835df28734b0e8008a5ebc41a477e9c87d8de71a868021b430d"
    sha256 cellar: :any,                 x86_64_linux:      "c6678ffeeceda443aa95a730a5436f65e7897451d09f238b51a82770631a69ce"
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

    shell_output("#{bin}/ty check #{testpath} 2>&1", 1)

    (testpath/"good.py").write <<~PYTHON
      def f(x: int) -> str:
          return str(x)
    PYTHON
    system bin/"ty", "check", testpath/"good.py"
  end
end

class Rustic < Formula
  desc "Fast, encrypted, and deduplicated backups powered by Rust"
  homepage "https://rustic.cli.rs"
  url "https://github.com/rustic-rs/rustic/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "41c496bee7dcfad0922d4d9e760be19f713ffaaa55fe92716943ca3ecc62d26e"
  license "Apache-2.0"
  head "https://github.com/rustic-rs/rustic.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9923a410b3599a2d561181bec3a636af60569e33c005e5f919e96a6961f512d3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "21c3cef57e96028dce3f73657931b98771388f0a13c31335bacaa1d57ca698e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f30762801614a4a300b5919bb3cb90d202fe79021def35a45cd47490caf1c293"
    sha256 cellar: :any,                 arm64_linux:       "973518e542739b866da281a98fcff4d394773b9224a2beed164b64e6e0912d57"
    sha256 cellar: :any,                 x86_64_linux:      "7c3b409323747c1e028a269a9ed3928d9bd37de6a6ac58f53cd8cd576417f6a0"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"rustic", "completions")
  end

  test do
    mkdir testpath/"rustic_repo"
    ENV["RUSTIC_REPOSITORY"] = testpath/"rustic_repo"
    ENV["RUSTIC_PASSWORD"] = "test"

    (testpath/"testfile").write("test test test")

    system bin/"rustic", "init"
    system bin/"rustic", "backup", "testfile"

    system bin/"rustic", "restore", "latest:testfile", testpath/"testfile_restore"
    assert compare_file testpath/"testfile", testpath/"testfile_restore"
  end
end

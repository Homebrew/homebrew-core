class SequoiaSq < Formula
  desc "Sequoia-PGP command-line tool"
  homepage "https://sequoia-pgp.org"
  url "https://static.crates.io/crates/sequoia-sq/sequoia-sq-1.5.1.crate"
  sha256 "4595a9049928871805149af80f27311fa7c735e3dfe53c91f738e04cddf195f1"
  license "LGPL-2.0-or-later"
  head "https://gitlab.com/sequoia-pgp/sequoia-sq.git", branch: "main"

  bottle do
    manifest_sha256 "fc0bf8eb68f9615c521ce7871d9f0e5c27bc352e8ed6d4184d13cc4f270c8407"
    sha256 cellar: :any, arm64_golden_gate: "677a97d0480c29692bde9b13e3d29163340367e6e12eecad0627070f4f806bc4"
    sha256 cellar: :any, arm64_tahoe:       "909e63eb01c02904e843d8e576848f37db6776787dbdce202d89ebb6a3930856"
    sha256 cellar: :any, arm64_sequoia:     "76f0c91b25416971d230fbc1801e25804b0c58f6662e9b2a1d9d5751ec3ee16e"
    sha256 cellar: :any, arm64_linux:       "266949aeec97d223a7fea756266a8335cd471cbb73f9ad5ab286e0046a272945"
    sha256 cellar: :any, x86_64_linux:      "23e1de71887707e6289636c2c30df819c444b613acf8f1c4ad4c3fdfb6ea0943"
  end

  depends_on "capnp" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "openssl@4"

  uses_from_macos "llvm" => :build
  uses_from_macos "bzip2"
  uses_from_macos "sqlite"

  conflicts_with "sq", "squirrel-lang", because: "both install `sq` binaries"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["OPENSSL_DIR"] = dep("openssl").opt_prefix
    ENV["ASSET_OUT_DIR"] = buildpath

    path = build.head? ? "tool" : "."
    system "cargo", "install", "--no-default-features", *std_cargo_args(features: "crypto-openssl", path:)
    man1.install Dir["man-pages/*.1"]

    bash_completion.install "shell-completions/sq.bash" => "sq"
    zsh_completion.install "shell-completions/_sq"
    fish_completion.install "shell-completions/sq.fish"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sq version 2>&1")

    output = pipe_output("#{bin}/sq packet armor", test_fixtures("test.gif").read, 0)
    assert_match "R0lGODdhAQABAPAAAAAAAAAAACwAAAAAAQABAAACAkQBADs=", output
  end
end

class SequoiaSq < Formula
  desc "Sequoia-PGP command-line tool"
  homepage "https://sequoia-pgp.org"
  url "https://static.crates.io/crates/sequoia-sq/sequoia-sq-1.5.0.crate"
  sha256 "43f230abc78a8daec8a06cfc8c1191045b7b210fee5bee50dc3f75bd9f22950e"
  license "LGPL-2.0-or-later"
  head "https://gitlab.com/sequoia-pgp/sequoia-sq.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a4710983c76c8d4a0519eb624d6bd321b2722cd99b3f110d53e26796da298692"
    sha256 cellar: :any, arm64_tahoe:       "90e7aee923e6f01aa080ff2b6a8c95e1b3ecc0dd1388b1c10ca331fd7f925e65"
    sha256 cellar: :any, arm64_sequoia:     "80efb29df8371f2978686015abae0b1b3d9297efeedfd95734a644be7092e4a5"
    sha256 cellar: :any, arm64_linux:       "04e2af43cb4fadad76b84ec496a5f0cabe50857e41cd403ee5c8a9674d988e7e"
    sha256 cellar: :any, x86_64_linux:      "9765fd7d79e29ae17d947fcbd149ddea80d6630b6d4551fdb7617dba214ad383"
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
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")
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

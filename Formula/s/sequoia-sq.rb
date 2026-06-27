class SequoiaSq < Formula
  desc "Sequoia-PGP command-line tool"
  homepage "https://sequoia-pgp.org"
  url "https://gitlab.com/sequoia-pgp/sequoia-sq/-/archive/v1.3.1/sequoia-sq-v1.3.1.tar.gz"
  sha256 "9f112096f413e195ec737c81abb5649604f16e1f6dbe64a8accc5bb3ad39e239"
  license "LGPL-2.0-or-later"
  revision 1
  head "https://gitlab.com/sequoia-pgp/sequoia-sq.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6d9a5df779564beafbc4a1c440b6b2bd4ce852137fff10eec2c64e72108fc168"
    sha256 cellar: :any, arm64_sequoia: "27bb98be25f600adbfad729fb85018f3f3501248ea06edfd9433d82f26c7954f"
    sha256 cellar: :any, arm64_sonoma:  "cfb5d9fe4ff590cafdf58579dcb387e5adecf50aa734ef4a9c05650d48bf7f5b"
    sha256 cellar: :any, sonoma:        "bc651ef16e1220dd8ae3fd31495324340d9d52a7f2a445ef59076f0e0923da75"
    sha256 cellar: :any, arm64_linux:   "9d1e757c09f0a52f89b2cf38ef63e62eebf8c6788bd057333c145f3b306c1e82"
    sha256 cellar: :any, x86_64_linux:  "1fcadb83b0670e6ff232b6673102f3c94eed3e552cf1b89bf28c9a31a6dc73fd"
  end

  depends_on "capnp" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "openssl@3"

  uses_from_macos "llvm" => :build
  uses_from_macos "bzip2"
  uses_from_macos "sqlite"

  conflicts_with "sq", "squirrel-lang", because: "both install `sq` binaries"

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")
    ENV["ASSET_OUT_DIR"] = buildpath

    system "cargo", "install", "--no-default-features", *std_cargo_args(features: "crypto-openssl")
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

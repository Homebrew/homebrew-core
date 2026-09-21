class SequoiaSq < Formula
  desc "Sequoia-PGP command-line tool"
  homepage "https://sequoia-pgp.org"
  url "https://gitlab.com/sequoia-pgp/sequoia-sq/-/archive/v1.4.1/sequoia-sq-v1.4.1.tar.gz"
  sha256 "d6c1fd6454b4f469913ab22de4fc6ec349f6effa1bd0423a4f68d868dfbbee39"
  license "LGPL-2.0-or-later"
  head "https://gitlab.com/sequoia-pgp/sequoia-sq.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "5ab6271093026566f938f68062dd2431070ed8526e5edc96e95077b52647cc38"
    sha256 cellar: :any, arm64_tahoe:       "5dd374a00324f2f3aaff69e05626a5eac6e774685d41aecaedac950703505b43"
    sha256 cellar: :any, arm64_sequoia:     "c383b86714c75e5f061b900f117defd67cb8f762699e9249654050bac18d39a5"
    sha256 cellar: :any, arm64_linux:       "1e4b2cca0210bfaee779794a0ba3f3948859b2ed184886ad51cb2919e1779ae8"
    sha256 cellar: :any, x86_64_linux:      "bf868f2eacab66e2a60f8a046ae8944a8d82b856a153cb9794d540657414ce50"
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

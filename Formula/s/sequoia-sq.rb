class SequoiaSq < Formula
  desc "Sequoia-PGP command-line tool"
  homepage "https://sequoia-pgp.org"
  url "https://gitlab.com/sequoia-pgp/sequoia-sq/-/archive/v1.4.0/sequoia-sq-v1.4.0.tar.gz"
  sha256 "c856bfb0f0c94a1b8f4b72a04a6eff1e1d3d24c377cb0b1e495688e9aad8467a"
  license "LGPL-2.0-or-later"
  head "https://gitlab.com/sequoia-pgp/sequoia-sq.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e9e61d139b48df4a934d57d48e4cdb18d6e524204121ce04018a9aa7a2cb6fc5"
    sha256 cellar: :any, arm64_sequoia: "04acde3c23daadeeea490a1a1165597720c25afab32ad5d167b04455800b8ac4"
    sha256 cellar: :any, arm64_sonoma:  "13cbe320497f9f9540034e69d0afc7398a315f488b547f32aef83caf8e343f32"
    sha256 cellar: :any, sonoma:        "190655e0e1e9f7367ebb1d9c066b559096355a84718d7676e3a61c1d4f8f1f0e"
    sha256 cellar: :any, arm64_linux:   "94ba7de7db749cb3be45e591deff4ca4646a77099fd0f499770c35ea7e31b2cd"
    sha256 cellar: :any, x86_64_linux:  "cecce68199801ece553c7ff977e6d676565b8509baed406af51922aa5de70260"
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

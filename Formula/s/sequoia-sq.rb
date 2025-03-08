class SequoiaSq < Formula
  desc "Sequoia-PGP command-line tool"
  homepage "https://sequoia-pgp.org"
  url "https://gitlab.com/sequoia-pgp/sequoia-sq/-/archive/v1.3.0/sequoia-sq-v1.3.0.tar.gz"
  sha256 "81ad0c5604d024ed131391350f520a99737bed37577ba418906dc271ad05215f"
  license "LGPL-2.0-or-later"
  head "https://gitlab.com/sequoia-pgp/sequoia-sq.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "42d5a5e30748ec3ef96e3c0f91479bd5dcb83559821bbde38feb982d3b3fc06c"
    sha256 cellar: :any,                 arm64_sonoma:  "21b7a80135482df6156b3b38efa246643528cc668e2400c1de0ea54ee39f4dc2"
    sha256 cellar: :any,                 arm64_ventura: "61c76e5db0c910718add3d1c3fa2c2ef4650cf814988de773ac5dea1343b8651"
    sha256 cellar: :any,                 sonoma:        "12400542eee5c394d5103227cb3b4bfae365ca21b94f2c60076cdfce9e754423"
    sha256 cellar: :any,                 ventura:       "230d73199b8bd00bdd73b617bcb21c453a291937e3fe3ee07066afec5e36c76b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f738775930c5b70ef3432724d405074702196bdf8431977465fd502571415889"
  end

  depends_on "capnp" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "gmp"
  depends_on "nettle"
  depends_on "openssl@3"

  uses_from_macos "llvm" => :build
  uses_from_macos "bzip2"
  uses_from_macos "sqlite"

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["ASSET_OUT_DIR"] = buildpath

    system "cargo", "install", *std_cargo_args
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

class SequoiaSq < Formula
  desc "Sequoia-PGP command-line tool"
  homepage "https://sequoia-pgp.org"
  url "https://gitlab.com/sequoia-pgp/sequoia-sq/-/archive/v1.1.0/sequoia-sq-v1.1.0.tar.gz"
  sha256 "3316902e1f52e8f01829b72014bda006ad9712ec3802703d395dbc6dbf50cb9d"
  license "LGPL-2.0-or-later"
  head "https://gitlab.com/sequoia-pgp/sequoia-sq.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "ac0a88e3da8b1ca1e58bd4cabe8f6856e33ced6ca76b199cd17a2525f266eaca"
    sha256 cellar: :any,                 arm64_sonoma:  "ac235bd5c73d7089051988d1e7dfc3dd50565ffc68b40bff128f74b2feebedd8"
    sha256 cellar: :any,                 arm64_ventura: "11d615f16715a94f9ecc916e698bcf7efdad504d0f7c5d1559f1fc5be68d8c21"
    sha256 cellar: :any,                 sonoma:        "10f79c2b3e41e4ac18562e18dcf950e6053cd956d77d7d02581ed48dd7a17bc8"
    sha256 cellar: :any,                 ventura:       "e7e1a11322a46eb655a10b1d2243ac86ec92065d5c4cfe6533de46a0f726581f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5bca0098990831f6be4e0431f32009a7a2030b464f870180cbb5a9464d5d86b"
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

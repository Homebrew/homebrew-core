class SequoiaSq < Formula
  desc "Sequoia-PGP command-line tool"
  homepage "https://sequoia-pgp.org"
  url "https://gitlab.com/sequoia-pgp/sequoia-sq/-/archive/v1.2.0/sequoia-sq-v1.2.0.tar.gz"
  sha256 "7dc01df61daed42a9db3f8c6056070a450875ea65685e174a402b7729a7d8c5e"
  license "LGPL-2.0-or-later"
  head "https://gitlab.com/sequoia-pgp/sequoia-sq.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5c6d0cc8c7022fe34214b3711886380de8408f3987f83280a569f5a220fcb65e"
    sha256 cellar: :any,                 arm64_sonoma:  "b1ba88f06b59d12f8b6bef062997f349c2aec12a73d11e4cada5b732abdaa4c8"
    sha256 cellar: :any,                 arm64_ventura: "9408acb013c12e29b511e8255bc6f85fcee96a973fd38fc5a4844b17ba125479"
    sha256 cellar: :any,                 sonoma:        "675d1ca1e6561302a8b4b6c03dd4b7ddad2eb1678f5dfbde63a94bf403d72441"
    sha256 cellar: :any,                 ventura:       "526e80f03c29bbbb198a1fc348cd6b8100d45096306309d4ec3bd91d7fb5eab7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "953505cd46baead0bab5f832ecc4684d3eef601ac23c7d6617211927aa5cb4ba"
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

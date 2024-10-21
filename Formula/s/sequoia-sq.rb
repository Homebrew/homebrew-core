class SequoiaSq < Formula
  desc "Sequoia-PGP command-line tool"
  homepage "https://sequoia-pgp.org"
  url "https://gitlab.com/sequoia-pgp/sequoia-sq/-/archive/v0.38.0/sequoia-sq-v0.38.0.tar.gz"
  sha256 "9fd32ad0de3388804e21205003821710d2faf99d5c85a50bd97da3e7e480921b"
  license "GPL-2.0-or-later"
  head "https://gitlab.com/sequoia-pgp/sequoia-sq.git", branch: "main"

  depends_on "capnp" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "gmp"
  depends_on "nettle"
  depends_on "openssl@3"

  on_linux do
    depends_on "llvm" => :build
    depends_on "bzip2"
    depends_on "sqlite"
  end

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["ASSET_OUT_DIR"] = buildpath

    system "cargo", "install", *std_cargo_args
    man1.install Dir["man-pages/*.1"]

    bash_completion.install "shell-completions/sq.bash"
    zsh_completion.install "shell-completions/_sq"
    fish_completion.install "shell-completions/sq.fish"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sq version 2>&1")
    assert_match "R0lGODdhAQABAPAAAAAAAAAAACwAAAAAAQABAAACAkQBADs=",
      shell_output("cat #{test_fixtures("test.gif")} | #{bin}/sq toolbox armor")
  end
end

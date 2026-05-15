class SequoiaChameleonGnupg < Formula
  desc "Reimplementatilon of gpg and gpgv using Sequoia"
  homepage "https://sequoia-pgp.org"
  url "https://gitlab.com/sequoia-pgp/sequoia-chameleon-gnupg/-/archive/v0.13.1/sequoia-chameleon-gnupg-v0.13.1.tar.bz2"
  sha256 "8e204784c83b2f17cdd591bd9e2e3df01f9f68527bb5c97aa181c8bec5c6f857"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "61d7aec3f79054bece9da5f074cd523f76a5eae6a833d571d297c9a8cec830a0"
    sha256 cellar: :any,                 arm64_sequoia: "2311543687172f7d8344999c541536ac205311176819910b598ee9cd8d84431b"
    sha256 cellar: :any,                 arm64_sonoma:  "de741debb4bea7b839d94e20a92332db0320c2b8bfe8a6492a0908313a7db371"
    sha256 cellar: :any,                 sonoma:        "01d2c0ab94f7fc524efe45f550dc9a8dfdc639885a215ac7b5a22b46397469ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c52d89c0162ecd6f5d998088684dc5279db8aaacf023dc2f2f92747a90abb832"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ebf8923298bf97bc5e41aae618e275eb9b5b34fc3669411659d26f7f7513567e"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "openssl@3"

  uses_from_macos "llvm" => :build
  uses_from_macos "bzip2"
  uses_from_macos "sqlite"

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["ASSET_OUT_DIR"] = buildpath

    system "cargo", "install", "--no-default-features", *std_cargo_args(features: "crypto-openssl")
    man1.install Dir["man-pages/*.1"]

    zsh_completion.install "shell-completions/_gpg-sq"
    zsh_completion.install "shell-completions/_gpgv-sq"
    bash_completion.install "shell-completions/gpg-sq.bash" => "gpg-sq"
    bash_completion.install "shell-completions/gpgv-sq.bash" => "gpgv-sq"
    fish_completion.install "shell-completions/gpg-sq.fish"
    fish_completion.install "shell-completions/gpgv-sq.fish"
  end

  test do
    assert_match "Chameleon #{version}", shell_output("#{bin}/gpg-sq --version")

    output = pipe_output("#{bin}/gpg-sq --enarmor", test_fixtures("test.gif").read, 0)
    assert_match "R0lGODdhAQABAPAAAAAAAAAAACwAAAAAAQABAAACAkQBADs=", output
  end
end

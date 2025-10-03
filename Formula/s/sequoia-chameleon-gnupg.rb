class SequoiaChameleonGnupg < Formula
  desc "Reimplementatilon of gpg and gpgv using Sequoia"
  homepage "https://sequoia-pgp.org"
  url "https://gitlab.com/sequoia-pgp/sequoia-chameleon-gnupg/-/archive/v0.13.1/sequoia-chameleon-gnupg-v0.13.1.tar.bz2"
  sha256 "8e204784c83b2f17cdd591bd9e2e3df01f9f68527bb5c97aa181c8bec5c6f857"
  license "GPL-3.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "28f73d4c9fe42708b00a6cc31b1944d40ef9ab28f19f555262580ffd02c7af8c"
    sha256 cellar: :any,                 arm64_sequoia: "5b91310a0e9767914f4e236560e5ca9e010e5251386ee843a36bddd67d44b8fa"
    sha256 cellar: :any,                 arm64_sonoma:  "27b24b86636d9645d07a03f3b317208a030ebf65c4c1d5720ce71b4b6da329ce"
    sha256 cellar: :any,                 arm64_ventura: "63e79260f1665bd08b3c837dc89484e652494dd77d91ebdecc523bc48ce6e3f1"
    sha256 cellar: :any,                 sonoma:        "0c04398a6a5a0ec0b24d8c9e17c8d32b60cd6506c3e123478372765d2c110e6e"
    sha256 cellar: :any,                 ventura:       "b040e893c7a651cf2487981dfa5ddf7efde8d5f7df18e2900757f6c761131709"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3f4855b69df13a6c051453ae00e4434063777d1f26e9d07cf1ef21d2f5e06c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3319626d5c818b6482bf2ba1c9cfd267447639975483dde222f430a33ba1dc82"
  end

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

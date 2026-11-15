class SequoiaChameleonGnupg < Formula
  desc "Reimplementatilon of gpg and gpgv using Sequoia"
  homepage "https://sequoia-pgp.org"
  license "GPL-3.0-or-later"
  revision 1

  stable do
    url "https://gitlab.com/sequoia-pgp/sequoia-chameleon-gnupg/-/archive/v0.13.1/sequoia-chameleon-gnupg-v0.13.1.tar.bz2"
    sha256 "8e204784c83b2f17cdd591bd9e2e3df01f9f68527bb5c97aa181c8bec5c6f857"

    # Backport only the openssl and openssl-sys version updates from
    # https://gitlab.com/sequoia-pgp/sequoia-chameleon-gnupg/-/commit/c0e62cad4f6c7594f18a8fd854fee6a91652f01d
    patch :DATA
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "93af757aac95cca95f5a042304150b5e612136ec9b40792ea0c266f7bc8142a6"
    sha256 cellar: :any, arm64_tahoe:       "c403c015707526a39bdc30b276e39b3f43e529cfbd2331666d2cb0dcb5af5577"
    sha256 cellar: :any, arm64_sequoia:     "903fe6979be7521f9a3fc85fc09826112f6dce38f17bf0e2d5daf9d1eea0725d"
    sha256 cellar: :any, arm64_linux:       "fe69399f6b62619ea10b49c548fbce34e02d1431f688a819e35ae35e5fbd1a3f"
    sha256 cellar: :any, x86_64_linux:      "3979ab2c848f1acfe583bc76f213a5139f6857a453f9fd7ddd18da1ceb1a1280"
  end

  head do
    url "https://gitlab.com/sequoia-pgp/sequoia-chameleon-gnupg.git", branch: "main"
    depends_on "capnp" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "openssl@4"

  uses_from_macos "llvm" => :build
  uses_from_macos "bzip2"
  uses_from_macos "sqlite"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")
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

__END__
diff --git a/Cargo.lock b/Cargo.lock
index 410f74e..47ef6d6 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -2158,15 +2158,14 @@ dependencies = [
 
 [[package]]
 name = "openssl"
-version = "0.10.69"
+version = "0.10.81"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "f5e534d133a060a3c19daec1eb3e98ec6f4685978834f2dbadfe2ec215bab64e"
+checksum = "77823a27f0babb03091cb9ed9ef80af3b39dbc82f97e8fa530374b7dafd87a45"
 dependencies = [
  "bitflags",
  "cfg-if",
  "foreign-types",
  "libc",
- "once_cell",
  "openssl-macros",
  "openssl-sys",
 ]
@@ -2190,9 +2189,9 @@ checksum = "d05e27ee213611ffe7d6348b942e8f942b37114c00cc03cec254295a4a17852e"
 
 [[package]]
 name = "openssl-sys"
-version = "0.9.104"
+version = "0.9.117"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "45abf306cbf99debc8195b66b7346498d7b10c210de50418b5ccd7ceba08c741"
+checksum = "b47e7e6bb2c38cd930d25a23b40fa52e068c10e85f3e03a7f5ba5aaca5713695"
 dependencies = [
  "cc",
  "libc",

class Rink < Formula
  desc "Unit conversion tool and library written in rust"
  homepage "https://rinkcalc.app/about"
  url "https://github.com/tiffany352/rink-rs/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "53f466f4043e0396bedbfdc916aac25cb23c3021137c846d57249678f42fb745"
  license all_of: ["MPL-2.0", "GPL-3.0-or-later"]

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9e985d83c66f57da6a0aaf73c17edd73e26a8f853f50f5f3eae80902b1361b02"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "24817050850c9a65be6a4b25840c4f4298b69f3937c9bcc02c93111fd257681b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a5dcb189aea4b2546735789169e0d4ada2fe938ee90a92cf83bc43255b353b2e"
    sha256 cellar: :any,                 arm64_linux:       "593e9cd5014a250efeb238ec96980b1f66db5c57790ac0178363641143e43fad"
    sha256 cellar: :any,                 x86_64_linux:      "d609fb49f477517f6a368d7979402a48210e5e9abc6aeb02a57ece3658ee7972"
  end

  depends_on "asciidoctor" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "curl"

  on_linux do
    depends_on "openssl@4" => :build
    depends_on "zlib-ng-compat" => :build
  end

  # Update to openssl 0.10.78 and openssl-sys 0.9.114 for minimum needed to use OpenSSL 4
  patch :DATA

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")

    system "make", "man"
    man1.install "build/rink.1"
    man5.install "build/rink-dates.5"
    man5.install "build/rink-defs.5"
    man5.install "build/rink.5"
    man7.install "build/rink.7"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rink --version")

    output = shell_output("#{bin}/rink '1 inch to centi meter'")
    assert_match "> 1 inch to centi meter", output
    assert_match "2.54 centi meter (length)", output
  end
end

__END__
diff --git a/Cargo.lock b/Cargo.lock
index e73c79b..6396e0f 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -1425,9 +1425,9 @@ checksum = "3fdb12b2476b595f9358c5161aa467c2438859caa136dec86c26fdd2efe17b92"
 
 [[package]]
 name = "openssl"
-version = "0.10.73"
+version = "0.10.78"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "8505734d46c8ab1e19a1dce3aef597ad87dcb4c37e7188231769bd6bd51cebf8"
+checksum = "f38c4372413cdaaf3cc79dd92d29d7d9f5ab09b51b10dded508fb90bb70b9222"
 dependencies = [
  "bitflags 2.5.0",
  "cfg-if 1.0.0",
@@ -1457,9 +1457,9 @@ checksum = "ff011a302c396a5197692431fc1948019154afc178baf7d8e37367442a4601cf"
 
 [[package]]
 name = "openssl-sys"
-version = "0.9.109"
+version = "0.9.114"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "90096e2e47630d78b7d1c20952dc621f957103f8bc2c8359ec81290d75238571"
+checksum = "13ce1245cd07fcc4cfdb438f7507b0c7e4f3849a69fd84d52374c66d83741bb6"
 dependencies = [
  "cc",
  "libc",

class Wthrr < Formula
  desc "Weather Companion for the Terminal"
  homepage "https://github.com/ttytm/wthrr-the-weathercrab"
  license "MIT"
  head "https://github.com/ttytm/wthrr-the-weathercrab.git", branch: "main"

  stable do
    url "https://github.com/ttytm/wthrr-the-weathercrab/archive/refs/tags/v1.2.1.tar.gz"
    sha256 "ff5b47f2046ebefa9ff28cb52ece49a06f7b89230578801c338c77802aa721e0"

    # Backport renovate Cargo.lock updates
    patch do
      url "https://github.com/ttytm/wthrr-the-weathercrab/commit/2c7676460787022916450e9fdb94a3f917341898.patch?full_index=1"
      sha256 "68ef0be8b65982f63c785e3ad1c3f1dded4ae8e2e8cc100b3cd3ab8c1d396a0d"
      type :backport
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7b7ded6fe6f3bcace79f5eded82a4d78aac60c6eabbb48fb5a0ab05be8e07e22"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fffeb331d7010937a3ed451b50bcefbb2b421db64aa6c05fb92eeea0733361e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "728353e1b8870844618d9dcf2664be705a7b865459120abffdaa36ff7d08138d"
    sha256 cellar: :any,                 arm64_linux:       "4c908b9dbcca8682b6e17ee27f563c4f7df72908319a8f0aedb302e810c019ff"
    sha256 cellar: :any,                 x86_64_linux:      "50094e252ea72e4ea305af6641420c52e598e49d26bfc3ddceda998ccc67127c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  # Update to openssl 0.10.78 and openssl-sys 0.9.114 for minimum needed to use OpenSSL 4
  patch :DATA

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wthrr --version")
    system bin/"wthrr", "-h"

    require "pty"

    PTY.spawn(bin/"wthrr", "-l", "en_US", "Kyoto") do |r, _w, pid|
      output = r.gets
      assert_match "Hey friend. I'm glad you are asking.", output
    ensure
      Process.kill("TERM", pid)
    end
  end
end

__END__
diff --git a/Cargo.lock b/Cargo.lock
index 1456628..50ae4e3 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -737,9 +737,9 @@ checksum = "1261fe7e33c73b354eab43b1273a57c8f967d0391e80353e51f764ac02cf6775"
 
 [[package]]
 name = "openssl"
-version = "0.10.68"
+version = "0.10.78"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "6174bc48f102d208783c2c84bf931bb75927a617866870de8a4ea85597f871f5"
+checksum = "f38c4372413cdaaf3cc79dd92d29d7d9f5ab09b51b10dded508fb90bb70b9222"
 dependencies = [
  "bitflags",
  "cfg-if",
@@ -769,9 +769,9 @@ checksum = "ff011a302c396a5197692431fc1948019154afc178baf7d8e37367442a4601cf"
 
 [[package]]
 name = "openssl-sys"
-version = "0.9.104"
+version = "0.9.114"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "45abf306cbf99debc8195b66b7346498d7b10c210de50418b5ccd7ceba08c741"
+checksum = "13ce1245cd07fcc4cfdb438f7507b0c7e4f3849a69fd84d52374c66d83741bb6"
 dependencies = [
  "cc",
  "libc",

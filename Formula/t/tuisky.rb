class Tuisky < Formula
  desc "TUI client for bluesky"
  homepage "https://github.com/sugyan/tuisky"
  url "https://github.com/sugyan/tuisky/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "b3db8969aa5152692f7178a17f51d694a2cc4e06bb8ff18e43b0f4c7a5d83fa8"
  license "MIT"
  head "https://github.com/sugyan/tuisky.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8016522e174aafd3ef5b3e07acf13f40a4527b59a46d5ea61bcacb778da17694"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "04e8e26ee06f440a31135e5f4992e8687acdbc3a94f5e00212ca2fb3e767bbea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6eab316d240901713ea4ad33331423d6c77e131cb26f46821b081572656658e2"
    sha256 cellar: :any,                 arm64_linux:       "aacedb1a58d66e750d016ac73a28d84e5cbe010325ce720e1f7634f65a22300e"
    sha256 cellar: :any,                 x86_64_linux:      "b6c49ba8f7579781e7c7d692ccbd81e7e54dbe4d621919a99036626ae410cc8e"
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

    pkgetc.install "config/example.config.toml" => "config.toml"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tuisky --version")

    begin
      output_log = testpath/"output.log"
      if OS.mac?
        pid = spawn bin/"tuisky", [:out, :err] => output_log.to_s
      else
        require "pty"
        r, _w, pid = PTY.spawn bin/"tuisky", [:out, :err] => output_log.to_s
        r.winsize = [80, 130]
      end
      sleep 1
      assert_match "https://bsky.social", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end

__END__
diff --git a/Cargo.lock b/Cargo.lock
index c03de05..a0f161e 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -1325,9 +1325,9 @@ dependencies = [
 
 [[package]]
 name = "openssl"
-version = "0.10.66"
+version = "0.10.78"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "9529f4786b70a3e8c61e11179af17ab6188ad8d0ded78c5529441ed39d4bd9c1"
+checksum = "f38c4372413cdaaf3cc79dd92d29d7d9f5ab09b51b10dded508fb90bb70b9222"
 dependencies = [
  "bitflags 2.6.0",
  "cfg-if",
@@ -1357,9 +1357,9 @@ checksum = "ff011a302c396a5197692431fc1948019154afc178baf7d8e37367442a4601cf"
 
 [[package]]
 name = "openssl-sys"
-version = "0.9.103"
+version = "0.9.114"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "7f9e8deee91df40a943c71b917e5874b951d32a802526c85721ce3b776c929d6"
+checksum = "13ce1245cd07fcc4cfdb438f7507b0c7e4f3849a69fd84d52374c66d83741bb6"
 dependencies = [
  "cc",
  "libc",

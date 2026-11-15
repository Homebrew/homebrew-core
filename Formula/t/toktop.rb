class Toktop < Formula
  desc "LLM usage monitor in terminal"
  homepage "https://github.com/htin1/toktop"
  url "https://github.com/htin1/toktop/archive/refs/tags/v0.1.5.tar.gz"
  sha256 "9e01566757971e7cf42dd881ea9e8a8a53bbda4dade210a3c80df71638418ee4"
  license "MIT"
  head "https://github.com/htin1/toktop.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a17a979c556745dac109cc15f77ea88f1f85748f4e2d1142dfc64ea38516f807"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d94dde0c21278442fc14e4e3e0b69762ae51f4cfd3c404d3ac754b7150cf67fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "128bed798080c3cae87394b84f387b2b9b20106130983f63f5de8dc0b5de83d1"
    sha256 cellar: :any,                 arm64_linux:       "639a2e9b90aba414c79d216162a58e1452ca9cb406f0a4af91c7d8bf8d1409e8"
    sha256 cellar: :any,                 x86_64_linux:      "17c79ce6b69aa148716a5336185a03b24f694a7842801eb2c735314a3e12c8c3"
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
    ENV["OPENAI_ADMIN_KEY"] = "test"
    ENV["ANTHROPIC_ADMIN_KEY"] = "test"
    assert_match "OpenAI", if OS.mac?
      pipe_output("#{bin}/toktop 2>&1", "\e", 1)
    else
      require "pty"
      r, w, pid = PTY.spawn("#{bin}/toktop 2>&1")
      r.winsize = [80, 43]
      w.write "q\nq"
      Process.wait(pid)
      r.read_nonblock(4096)
    end
  end
end

__END__
diff --git a/Cargo.lock b/Cargo.lock
index 5048ed1..ab9df7a 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -896,9 +896,9 @@ checksum = "384b8ab6d37215f3c5301a95a4accb5d64aa607f1fcb26a11b5303878451b4fe"
 
 [[package]]
 name = "openssl"
-version = "0.10.74"
+version = "0.10.78"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "24ad14dd45412269e1a30f52ad8f0664f0f4f4a89ee8fe28c3b3527021ebb654"
+checksum = "f38c4372413cdaaf3cc79dd92d29d7d9f5ab09b51b10dded508fb90bb70b9222"
 dependencies = [
  "bitflags",
  "cfg-if",
@@ -928,9 +928,9 @@ checksum = "d05e27ee213611ffe7d6348b942e8f942b37114c00cc03cec254295a4a17852e"
 
 [[package]]
 name = "openssl-sys"
-version = "0.9.110"
+version = "0.9.114"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "0a9f0075ba3c21b09f8e8b2026584b1d18d49388648f2fbbf3c97ea8deced8e2"
+checksum = "13ce1245cd07fcc4cfdb438f7507b0c7e4f3849a69fd84d52374c66d83741bb6"
 dependencies = [
  "cc",
  "libc",

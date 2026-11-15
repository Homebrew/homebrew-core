class Tiny < Formula
  desc "Terminal IRC client"
  homepage "https://github.com/osa1/tiny"
  license "MIT"
  head "https://github.com/osa1/tiny.git", branch: "master"

  stable do
    url "https://github.com/osa1/tiny/archive/refs/tags/v0.13.0.tar.gz"
    sha256 "599697fa736d7500b093566a32204691093bd16abd76f43a76b761487a7c584c"

    # Backport some dependency updates
    patch do
      url "https://github.com/osa1/tiny/commit/2ee969a521608eb4f4bf3edefbf546f763019a4a.patch?full_index=1"
      sha256 "684534ce9e3555a8edc1438ff3fdd5b87eb8c3a264f62e9b93b2016b01ac7e02"
      type :backport
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1bbced67ee76780d5bcd0d08348b1e8b16c87d2f77ed3d2008a788616a621172"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "409cf746d200608b66065da0c9258866c93931b4cbd257d9e1e8dfdf5906d863"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "54b3020e74188e882e7f7909636752940895082a00de6fa37ced26a77636fd81"
    sha256 cellar: :any,                 arm64_linux:       "68dae22b8ae2fccd982753cdd6cc6786ac6e59943328fc1ced598c6bfa03cc52"
    sha256 cellar: :any,                 x86_64_linux:      "c9b7948f34fbd53cd9e9b6a6c67d2b1f711b8225064429b650dba520af878b75"
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
    odie "Remove `cargo generate-lockfile`" if build.stable? && version > "0.13.0"
    system "cargo", "generate-lockfile"
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # Replace tls-rustls with tls-native
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "crates/tiny", features: "tls-native")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tiny --version")

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"tiny", [:out, :err] => output_log.to_s
      sleep 1
      assert_match "tiny couldn't find a config file", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end

__END__
diff --git a/Cargo.lock b/Cargo.lock
index 6f2e771..4a95afd 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -568,9 +568,9 @@ checksum = "42f5e15c9953c5e4ccceeb2e7382a716482c34515315f7b03532b8b4e8393d2d"
 
 [[package]]
 name = "openssl"
-version = "0.10.72"
+version = "0.10.78"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "fedfea7d58a1f73118430a55da6a286e7b044961736ce96a16a17068ea25e5da"
+checksum = "f38c4372413cdaaf3cc79dd92d29d7d9f5ab09b51b10dded508fb90bb70b9222"
 dependencies = [
  "bitflags 2.9.1",
  "cfg-if",
@@ -600,9 +600,9 @@ checksum = "d05e27ee213611ffe7d6348b942e8f942b37114c00cc03cec254295a4a17852e"
 
 [[package]]
 name = "openssl-sys"
-version = "0.9.108"
+version = "0.9.114"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "e145e1651e858e820e4860f7b9c5e169bc1d8ce1c86043be79fa7b7634821847"
+checksum = "13ce1245cd07fcc4cfdb438f7507b0c7e4f3849a69fd84d52374c66d83741bb6"
 dependencies = [
  "cc",
  "libc",

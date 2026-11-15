class So < Formula
  desc "Terminal interface for StackOverflow"
  homepage "https://github.com/samtay/so"
  url "https://github.com/samtay/so/archive/refs/tags/v0.4.10.tar.gz"
  sha256 "36d8bc53b9c05e242fd4c9ba8ae447fae6c4a35d8c7e071f8994a7c0f07c225d"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "222ad99544146a353458903cdb63c6e22f8fb4c8d08ea4c90c29f5b70224d7d7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5d09567fcd0b8e27d9e75a80a3ced056dd069cb21c7deed149bceb7ed7ff2dac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0a77c9b7b12cc51f2031178736d8748eaa5daff5d9d46c19194c399355176d18"
    sha256 cellar: :any,                 arm64_linux:       "d588540276e0569d11ba909bebffa0871e6811bcdf0d97b8b34b943ab1876295"
    sha256 cellar: :any,                 x86_64_linux:      "8c2b63716e3dc191a59fd5309a6b7d40898009388cc9e724c452e503faa5c9af"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  conflicts_with "solod", because: "both install `so` binaries"

  # Update to openssl 0.10.78 and openssl-sys 0.9.114 for minimum needed to use OpenSSL 4
  patch :DATA

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "pty"

    env_vars = { "LC_CTYPE" => "en_US.UTF-8", "LANG" => "en_US.UTF-8", "TERM" => "xterm" }
    opts = %w[--search-engine stackexchange --limit 1 --lucky]
    output_log = testpath/"output.log"
    PTY.spawn(env_vars, bin/"so", *opts, "how do I exit Vim", [:out, :err] => output_log.to_s) do |r, w, pid|
      r.winsize = [80, 130]
      sleep 3
      w.puts "q"
      sleep 2
    ensure
      r.close
      w.close
      Process.wait(pid)
    end
    assert_match ":wq", output_log.read
  end
end

__END__
diff --git a/Cargo.lock b/Cargo.lock
index a9d4dbc..e0c5824 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -1567,9 +1567,9 @@ checksum = "b410bbe7e14ab526a0e86877eb47c6996a2bd7746f027ba551028c925390e4e9"
 
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
@@ -1599,9 +1599,9 @@ checksum = "ff011a302c396a5197692431fc1948019154afc178baf7d8e37367442a4601cf"
 
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

class Rathole < Formula
  desc "Reverse proxy for NAT traversal"
  homepage "https://github.com/rathole-org/rathole"
  url "https://github.com/rathole-org/rathole/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "c8698dc507c4c2f7e0032be24cac42dd6656ac1c52269875d17957001aa2de41"
  license "Apache-2.0"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f7a5a39c307169ea45af5cdfa5958d3b4093314599a0b591358d9316a5536d74"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "21b198d97dc178e4c141942ff40221c52cc9ee4d42574b6f19615d5f8981e794"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "596988e3c92c9256a1584176b38a95a3a72010ae9c339c3ae69ceb0357ac9f11"
    sha256 cellar: :any,                 arm64_linux:       "6db8fe242c4528c441431821850a3f0a9f18d17f50baec0d53897c50122fbfa9"
    sha256 cellar: :any,                 x86_64_linux:      "67b7da6d7b96c59a9a17a964c595a09b1ee30490e69b6d1fa665d0ef712b02ea"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  # rust 1.80 build patch
  patch do
    file "Patches/rathole/rust-1.80.patch"
    type :unofficial
    resolves "https://github.com/rathole-org/rathole/issues/380"
  end

  # Update to openssl 0.10.78 and openssl-sys 0.9.114 for minimum needed to use OpenSSL 4
  # Issue ref: https://github.com/rathole-org/rathole/issues/475
  patch :DATA

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  service do
    run [opt_bin/"rathole", "#{etc}/rathole/rathole.toml"]
    keep_alive true
    log_path var/"log/rathole.log"
    error_log_path var/"log/rathole.log"
  end

  test do
    bind_port = free_port
    service_port = free_port

    (testpath/"rathole.toml").write <<~TOML
      [server]
      bind_addr = "127.0.0.1:#{bind_port}"#{" "}
      default_token = "1234"#{" "}

      [server.services.foo]
      bind_addr = "127.0.0.1:#{service_port}"
    TOML

    read, write = IO.pipe
    fork do
      exec bin/"rathole", "-s", testpath/"rathole.toml", out: write
    end
    sleep 5

    output = read.gets
    assert_match(/Listening at 127.0.0.1:#{bind_port}/i, output)

    assert_match(/Build Version:\s*#{version}/, shell_output("#{bin}/rathole --version"))
  end
end

__END__
diff --git a/Cargo.lock b/Cargo.lock
index 95fb8ac..099eb9d 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -1294,9 +1294,9 @@ checksum = "624a8340c38c1b80fd549087862da4ba43e08858af025b236e509b6649fc13d5"
 
 [[package]]
 name = "openssl"
-version = "0.10.57"
+version = "0.10.78"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "bac25ee399abb46215765b1cb35bc0212377e58a061560d8b29b024fd0430e7c"
+checksum = "f38c4372413cdaaf3cc79dd92d29d7d9f5ab09b51b10dded508fb90bb70b9222"
 dependencies = [
  "bitflags 2.4.0",
  "cfg-if",
@@ -1335,9 +1335,9 @@ dependencies = [
 
 [[package]]
 name = "openssl-sys"
-version = "0.9.93"
+version = "0.9.114"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "db4d56a4c0478783083cfafcc42493dd4a981d41669da64b4572a2a089b51b1d"
+checksum = "13ce1245cd07fcc4cfdb438f7507b0c7e4f3849a69fd84d52374c66d83741bb6"
 dependencies = [
  "cc",
  "libc",

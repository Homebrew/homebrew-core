class River < Formula
  desc "Reverse proxy application, based on the pingora library from Cloudflare"
  homepage "https://www.memorysafety.org/initiative/reverse-proxy/"
  url "https://github.com/memorysafety/river/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "fe96d3693d60be06d0d1810954835f79139495b890b597f42c2b0bfa2bd8c7a6"
  license "Apache-2.0"
  head "https://github.com/memorysafety/river.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_golden_gate: "ae1e3320e450302e6beb74cdb0e318341c2a7951a11f3a4795ccef36407ecfe6"
    sha256 cellar: :any, arm64_tahoe:       "ddb809719d4724d1456b74877c9a54aabf7f62facb52872b92233326133a41e1"
    sha256 cellar: :any, arm64_sequoia:     "c4816a178a1648664702bb58d7c0dedc738eb0c2029fa23e39409e4d7f073d59"
    sha256 cellar: :any, arm64_linux:       "51d48149065e9379799a7bd55a3be05fc8d60362128011a4ceee584ece0ac342"
    sha256 cellar: :any, x86_64_linux:      "edc1e10ce97a4de7c702ebceff1be80d3cfdbbebf650e3d5ecdf1bb2d76d5574"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  # `pandora-web-server` moved off GitHub, so the pinned git dependency 404s
  patch do
    url "https://github.com/memorysafety/river/commit/d7de7566ab1cccb3a8c46c609e9ae5d511a9b0ae.patch?full_index=1"
    sha256 "23626140f673e189fa67145eb6c25e205536ecdddd784a03836b8da3577ae718"
    type :unofficial
    resolves "https://github.com/memorysafety/river/pull/92"
  end

  # Update to openssl-sys 0.9.114 for minimum needed to use OpenSSL 4
  patch :DATA

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")

    system "cargo", "install", *std_cargo_args(path: "source/river")
  end

  test do
    require "utils/linkage"

    (testpath/"example-config.toml").write <<~TOML
      [system]
        [[basic-proxy]]
        name = "Example Config"
        [basic-proxy.connector]
        proxy_addr = "127.0.0.1:80"
    TOML
    system bin/"river", "--validate-configs", "--config-toml", testpath/"example-config.toml"

    [
      formula_opt_lib("openssl@4")/shared_library("libssl"),
      formula_opt_lib("openssl@4")/shared_library("libcrypto"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin/"river", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end

__END__
diff --git a/Cargo.lock b/Cargo.lock
index 7057f43..08fc409 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -1229,9 +1229,9 @@ checksum = "3fdb12b2476b595f9358c5161aa467c2438859caa136dec86c26fdd2efe17b92"
 
 [[package]]
 name = "openssl"
-version = "0.10.66"
+version = "0.10.78"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "9529f4786b70a3e8c61e11179af17ab6188ad8d0ded78c5529441ed39d4bd9c1"
+checksum = "f38c4372413cdaaf3cc79dd92d29d7d9f5ab09b51b10dded508fb90bb70b9222"
 dependencies = [
  "bitflags 2.5.0",
  "cfg-if",
@@ -1270,9 +1270,9 @@ dependencies = [
 
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

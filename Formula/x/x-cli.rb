class XCli < Formula
  desc "Command-line power tool for Twitter"
  homepage "https://github.com/sferik/x-cli"
  license "MIT"
  head "https://github.com/sferik/x-cli.git", branch: "main"

  stable do
    url "https://github.com/sferik/x-cli/archive/refs/tags/v5.0.0.tar.gz"
    sha256 "30685de7d87d385a1c74b6ef47732c8b5259fe50f434efd651757e5529cc2fe9"

    on_linux do
      depends_on "openssl@4"
    end

    # Update to openssl 0.10.78 and openssl-sys 0.9.114 for minimum needed to use OpenSSL 4
    # TODO: Remove on next release along with OpenSSL dependency due to
    # https://github.com/sferik/x-cli/commit/0dea542d83ac50065a96602467f25bdbec3c11b9
    patch :DATA
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "581fa1294754ee18b605d1a971843dca8c92702bffac37b4e07d1d3bb2e6a356"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "852cce2762b67456aa39000532c63778ced8169b467b0929d1784966c4bb3003"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e0135846a45437ebbd360004d2d82000c3b15b814cb383c8f6d2ec40cea54202"
    sha256 cellar: :any,                 arm64_linux:       "5dfd972fca71b658b928ebdefbe063032973176a531435cdf3fdcfb3a85fa73d"
    sha256 cellar: :any,                 x86_64_linux:      "6eda7a318024390837b04d74ebda57c7426b103084475aded66a55fb4441aac5"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_macos do
    conflicts_with "xorg-server", because: "both provide an `x` binary"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # https://github.com/sferik/x-cli/issues/475
    inreplace "Cargo.toml", 'version = "6.0.0"', 'version = "5.0.0"'

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/x --version")
    assert_match "No active credentials found in profile", shell_output("#{bin}/x whoami 2>&1", 1)
  end
end

__END__
diff --git a/Cargo.lock b/Cargo.lock
index e6b7bed..eaadf09 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -1114,9 +1114,9 @@ checksum = "384b8ab6d37215f3c5301a95a4accb5d64aa607f1fcb26a11b5303878451b4fe"
 
 [[package]]
 name = "openssl"
-version = "0.10.75"
+version = "0.10.78"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "08838db121398ad17ab8531ce9de97b244589089e290a384c900cb9ff7434328"
+checksum = "f38c4372413cdaaf3cc79dd92d29d7d9f5ab09b51b10dded508fb90bb70b9222"
 dependencies = [
  "bitflags 2.11.0",
  "cfg-if",
@@ -1146,9 +1146,9 @@ checksum = "7c87def4c32ab89d880effc9e097653c8da5d6ef28e6b539d313baaacfbafcbe"
 
 [[package]]
 name = "openssl-sys"
-version = "0.9.111"
+version = "0.9.114"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "82cab2d520aa75e3c58898289429321eb788c3106963d0dc886ec7a5f4adc321"
+checksum = "13ce1245cd07fcc4cfdb438f7507b0c7e4f3849a69fd84d52374c66d83741bb6"
 dependencies = [
  "cc",
  "libc",

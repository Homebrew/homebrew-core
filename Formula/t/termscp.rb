class Termscp < Formula
  desc "Feature rich terminal file transfer and explorer"
  # https://termscp.veeso.dev is not accessible, upstream bug report, https://github.com/veeso/termscp/issues/420
  homepage "https://github.com/veeso/termscp"
  url "https://github.com/veeso/termscp/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "c07e2b82cb1cc327d977548e24d27fbbda8ee0cc4f2c3df9fb1b90c6e971e568"
  license "MIT"
  head "https://github.com/veeso/termscp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "16738eb10940aeb04ac6f2f0438d41aa0b78e5b5b5c8d84442ffac69286711ab"
    sha256 cellar: :any,                 arm64_sequoia: "e0d20562754944a0ac3e774502710f36d3887cf69c7f88e4a9336b935923ad63"
    sha256 cellar: :any,                 arm64_sonoma:  "9cd2f95da5c27e3675ec723a03365d68b1fe86a280a87b513ada537a9efe89ca"
    sha256 cellar: :any,                 sonoma:        "5f1330c3dfbfc8bddf5ed780eb650e178c353bfdbeff2d553911a74ad27c2d60"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d38dcba45f2b5fe2356162fb896bca365a70c2bd008405ef79c39aac8f82233e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ee69ebb96a07482273391ce05523e81299de73393aacc1c89411e243aa59b20"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"
  depends_on "samba"

  on_linux do
    depends_on "dbus"
    depends_on "zlib-ng-compat"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    require "pty"
    PTY.spawn(bin/"termscp", "config") do |_r, _w, pid|
      sleep 10
      Process.kill 9, pid
    end
  end
end

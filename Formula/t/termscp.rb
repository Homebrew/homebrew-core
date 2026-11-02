class Termscp < Formula
  desc "Feature rich terminal file transfer and explorer"
  # https://termscp.veeso.dev is not accessible, upstream bug report, https://github.com/veeso/termscp/issues/420
  homepage "https://termscp.rs"
  url "https://github.com/veeso/termscp/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "d660d7dc47ce7230d426d3d20a875d2b675d610f3e91b79385fc946f1ec45adf"
  license "MIT"
  head "https://github.com/veeso/termscp.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6e4734f7db2dc7d3837cecd9bc37555c84bd80934670bdedc9521b98e3af9139"
    sha256 cellar: :any, arm64_tahoe:       "0b40c361a17a5da72c7473c23c08736c4a075b240640c911cd825492155074fe"
    sha256 cellar: :any, arm64_sequoia:     "1a62ad52c72a57f819332b44d8ea828376a2ac6fffeb9e40f8699b830f2ca6dc"
    sha256 cellar: :any, arm64_linux:       "05a1199d6f7c1686ab6fda3c651eed1bb5f7a18f733397958d3868a8a20e1795"
    sha256 cellar: :any, x86_64_linux:      "11f222a9fd6539aedfe329106560a053236b479fbb2691b27f683c4d7dbfd2a1"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"
  depends_on "samba"

  on_linux do
    depends_on "dbus"
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def openssl = deps.map(&:name).find { |d| d.match?(/^openssl(@\d+(\.\d+)*)?$/) }

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix(openssl)

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

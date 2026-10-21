class Termscp < Formula
  desc "Feature rich terminal file transfer and explorer"
  # https://termscp.veeso.dev is not accessible, upstream bug report, https://github.com/veeso/termscp/issues/420
  homepage "https://termscp.rs"
  url "https://github.com/veeso/termscp/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "378b06607669edd6fdbcf1f3e040928b4a5e41c3792334d8b140270bd9afe0b7"
  license "MIT"
  head "https://github.com/veeso/termscp.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "229d4098d3139ed200796dbe72144d47366ec476de7b8621f77019eccf36c975"
    sha256 cellar: :any, arm64_tahoe:       "74791107963ec3b77072b7c646b061d5af9cb25b454360f8412a0b0f9edc64b2"
    sha256 cellar: :any, arm64_sequoia:     "db1dae93d335a3b99fd20da25b89b23ad603fa0327caeb9037eb9f3d4a5042e1"
    sha256 cellar: :any, arm64_linux:       "ec6c0a71424e1b4d0c783262fe94af59e515884397da87f07d699fee2fd1429d"
    sha256 cellar: :any, x86_64_linux:      "72db075e5c9f209242ee760b1bd18d6bd6596ae39e9610b6e71b26b860bc7af9"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"
  depends_on "samba"

  on_linux do
    depends_on "dbus"
    depends_on "zlib-ng-compat"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")

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

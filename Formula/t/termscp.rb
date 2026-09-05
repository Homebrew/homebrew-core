class Termscp < Formula
  desc "Feature rich terminal file transfer and explorer"
  # https://termscp.veeso.dev is not accessible, upstream bug report, https://github.com/veeso/termscp/issues/420
  homepage "https://termscp.rs"
  url "https://github.com/veeso/termscp/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "fe35ae14d72a3e40f43532c44ffbced9667ca515c82b93ce2b4398b768fd1113"
  license "MIT"
  head "https://github.com/veeso/termscp.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "66ffc3b3b471ef4ce25c5e3d2671288408463b343933406fa7b29cdbde4ab83c"
    sha256 cellar: :any, arm64_sequoia: "7efb6875872adf0d7581f5d4a1768205bc12eefb2b573e4bb1eedde435605888"
    sha256 cellar: :any, arm64_sonoma:  "297b0c32b09e07d5a03a7ba59d0c508c09ab9ce24feebaa240401e0c23e56e27"
    sha256 cellar: :any, arm64_linux:   "62a49ec5f6d76aae853fd84563201e50c8e7e3104cd556b018280c34da05208e"
    sha256 cellar: :any, x86_64_linux:  "bd7c8fc286d3a4e9672c91ba3255f5f0c34ecfc088ff41d1248f5fb537e78035"
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
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")

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

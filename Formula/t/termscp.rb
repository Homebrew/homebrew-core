class Termscp < Formula
  desc "Feature rich terminal file transfer and explorer"
  homepage "https://termscp.veeso.dev/"
  url "https://github.com/veeso/termscp/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "0f5316b43335896012c18cba20fa40cbf4eb2e53961fbfa29d560318ae0eaf74"
  license "MIT"
  head "https://github.com/veeso/termscp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f310d48b60ce47ce23c4e3660298995c2e77c7af57e422f0a6420738be09bf34"
    sha256 cellar: :any,                 arm64_sequoia: "38d2398585233bd05037a99e307e16b1fb7984616ebf695c3fc04574ed1cec3e"
    sha256 cellar: :any,                 arm64_sonoma:  "56e58ad9fea27cfbfef20cf64b4d44e69482e95e4195f2b45c1bad877c618198"
    sha256 cellar: :any,                 sonoma:        "8a35830d83a5a6c7bcad7aa7bd386b2ca1463866910556ed45bd7b6cf41165f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1ceac3a482221ac92e79d70fb8c5ab31c75c856b75b128e3c04b8dafdd419dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e441b01060fc39404650fa18f3f3f4059cd50442ad72c129689595dbcca57f37"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"
  depends_on "samba"

  uses_from_macos "zlib"

  on_linux do
    depends_on "dbus"
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

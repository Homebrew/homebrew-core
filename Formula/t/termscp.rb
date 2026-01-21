class Termscp < Formula
  desc "Feature rich terminal file transfer and explorer"
  homepage "https://termscp.veeso.dev/"
  url "https://github.com/veeso/termscp/archive/refs/tags/v0.19.1.tar.gz"
  sha256 "04248fc89e71a050463ad1824eccab4c04d34bff3126a8f9e26a77c75fe55b0f"
  license "MIT"
  head "https://github.com/veeso/termscp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d6b5cf7389ef5eee4d8d95379a8d988959f41b76843eecb53af9cdc744fd3f17"
    sha256 cellar: :any,                 arm64_sequoia: "85c7d904187fdbc4a264c7f147c35314ed952db4c31e00095e53b5611852a25c"
    sha256 cellar: :any,                 arm64_sonoma:  "e4001104a7299738e85635833c79f6189fe4bab9d2184275b6a998bfb51a2528"
    sha256 cellar: :any,                 sonoma:        "f926eafbd17cab0bd7c289d28ef60a167811d89ebfc92ab4d38ee5475c1e2db9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb4cae56b048e15d8da7c00fd5035df24a836efb96f18dfc82ee98371c231a36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa5531d08369e20346ad30474907f6e2a8653df87a72af042a54e5c5ec75a7e3"
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

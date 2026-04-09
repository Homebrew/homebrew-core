class Termscp < Formula
  desc "Feature rich terminal file transfer and explorer"
  homepage "https://termscp.veeso.dev/"
  url "https://github.com/veeso/termscp/archive/refs/tags/v0.19.1.tar.gz"
  sha256 "04248fc89e71a050463ad1824eccab4c04d34bff3126a8f9e26a77c75fe55b0f"
  license "MIT"
  head "https://github.com/veeso/termscp.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "8bdec1e7b0df8b1245316318cd2a94add2b2a3bd6e87c6b1ec45498401c19b1f"
    sha256 cellar: :any,                 arm64_sequoia: "3a359010c1e22734ee9576b9a11202eeb1f6da04b3bb443f665dff126a678503"
    sha256 cellar: :any,                 arm64_sonoma:  "af65ce15e43152d630e7bb55a564a255e06c085b63fa3b37c3194778b627fe2e"
    sha256 cellar: :any,                 sonoma:        "29b1da4bed40847c693bb52e32511d4dfc53e6ac04524a3217e5cf0282a47f13"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa3958d217ee1d3a5d45de489b1cfb4df90587269211060643017c9ff45e5308"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0bec0fcc27065085c36f6cf69efec45e3d7744ff5892c6cadc4293c8de73962"
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

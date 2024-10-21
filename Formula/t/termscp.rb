class Termscp < Formula
  desc "Feature rich terminal file transfer and explorer"
  homepage "https://termscp.veeso.dev/"
  license "MIT"
  head "https://github.com/veeso/termscp.git", branch: "main"

  stable do
    url "https://github.com/veeso/termscp/archive/refs/tags/v0.16.0.tar.gz"
    sha256 "58f3b4770c5d1c5d7998af88b6df8c6a53dee4409f2cf6ea676caccec79cdb7f"

    # rust 1.82.0 build patch
    patch do
      url "https://github.com/veeso/termscp/commit/69f821baef21fac5ef4db237467a302b8ead22ea.patch?full_index=1"
      sha256 "108dc7dec63d628e3eb5981de848040b048e7e2ddb476be825fc4e700fc3685c"
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "f6bc9491cfb183a0253284a59e8b23a8ead5b3a598699734602ca197f6149244"
    sha256 cellar: :any,                 arm64_sonoma:  "3e75b416a5dd48ee508ba9623a0a3a9744a6b7fbaf87d110364c4c7f949e48a2"
    sha256 cellar: :any,                 arm64_ventura: "96d45e7c37c819a6c16cce2797ffdaba58a93a30e20b6b5c3098794edd4fe08a"
    sha256 cellar: :any,                 sonoma:        "b77dfff6692b0afae87b3c15d61b7ff539e6de83b3c633b929054991dc55d79f"
    sha256 cellar: :any,                 ventura:       "434d855df167d306ba7207cc06bacf121721d47f375a9b6aaac1ac398c10727d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5680967d070271bbe21209c027e6b251bf029efda6e426f256e1e5179813c277"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "dbus"
    depends_on "samba"
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

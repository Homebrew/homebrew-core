class Termscp < Formula
  desc "Feature rich terminal file transfer and explorer"
  homepage "https://termscp.veeso.dev/"
  url "https://github.com/veeso/termscp/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "3791b4c4b63dd4ea31b6e4d7be754edf9441c5a84c9e7be878463411c4337588"
  license "MIT"
  head "https://github.com/veeso/termscp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9b0ebfc7d1e98d38f9a60557b4c17746b24c62634beb0117d7fa033549d20b67"
    sha256 cellar: :any,                 arm64_sonoma:  "0134e8eb5be800b3dd71f9d1924df8c83500c6fb0b83e48e22644f91873b830a"
    sha256 cellar: :any,                 arm64_ventura: "9fb082121f4c9fec8023e9d2b06238155dd0e504891bb2485b4110c3a7759e0b"
    sha256 cellar: :any,                 sonoma:        "6cec211fe0514243a27ad595b7f7f11ad871a0b47d26534e09ecac5dff811f8b"
    sha256 cellar: :any,                 ventura:       "8e51d0d0f3286718ab030dbc926b20cbf444b4bb286b7ecd38937308df549717"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed399ac73da3fd8546765a6d84ee1438101316f12996f2468414a8ae0b4d6a3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f36219c281e9b898a73a0f0fd79ba0bdbc0a36675a4503d30282a272d87e0a90"
  end

  depends_on "pkgconf" => :build
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

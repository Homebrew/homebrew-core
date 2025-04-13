class Termscp < Formula
  desc "Feature rich terminal file transfer and explorer"
  homepage "https://termscp.veeso.dev/"
  url "https://github.com/veeso/termscp/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "ada7bbf513104272687c703217f2cc45f834af979fa6bde1b7ab4ee059d67669"
  license "MIT"
  head "https://github.com/veeso/termscp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f1f6a863d2464e7be10654d7eff0d2922f24a101edeeadb52c9d1e016b1ac222"
    sha256 cellar: :any,                 arm64_sonoma:  "1fe7c2905c834353f25532a2712d4101c56d94de88550607410ce158e42b9e41"
    sha256 cellar: :any,                 arm64_ventura: "80643a20f1a6e4220a1a34c10bbc8ad9097c85d4ea26a43c0950aa8574ce03dc"
    sha256 cellar: :any,                 sonoma:        "bb8a6aa8bc2c40059fddd9d0bf432d859c3be784ae7b1ba60126b342c56477c1"
    sha256 cellar: :any,                 ventura:       "e3b7f899953f98ef98f4e1408ccb25e4d00770d6e21b82b89c00c98835250b51"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a3def80676f3340189e3b2a41072bd4e43c3ce9144ef4b53a5f3b9a7cb6f1a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b97ee5fc207ce372552809e310c18e8aad4b8c0fa15c76ca900681a372ae7aa"
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

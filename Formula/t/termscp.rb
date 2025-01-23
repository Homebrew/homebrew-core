class Termscp < Formula
  desc "Feature rich terminal file transfer and explorer"
  homepage "https://termscp.veeso.dev/"
  url "https://github.com/veeso/termscp/archive/refs/tags/v0.16.1.tar.gz"
  sha256 "318673db7d4c8b580f8f6a2b4e305fed3e7afc151217be5e16cf1a8f33fc2af4"
  license "MIT"
  head "https://github.com/veeso/termscp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2b75f4e9766d4fcbd48bc687b4748b185b33e231df05156e5bbac26a9aac70b4"
    sha256 cellar: :any,                 arm64_sonoma:  "5b32e256d2194f098ccb0a4e607448a98302c2540293c543be13fb33306cca3b"
    sha256 cellar: :any,                 arm64_ventura: "35ee471631fdb7dd12e8ed0f86fbae1e6eed916f37a0a05d70210d0cf2c926d1"
    sha256 cellar: :any,                 sonoma:        "ac38e634acb2b732c9eea95046b6483de1d746822bd03036a5a30e45d105b597"
    sha256 cellar: :any,                 ventura:       "5f6b391675789a9ac469ca554dbe36771b12d5f96737ae2b307723d61068588a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c205c5785124bee178c50b264518b55a5365c83a53dc5e694dd473e8710c166e"
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

class Termscp < Formula
  desc "Feature rich terminal file transfer and explorer"
  # https://termscp.veeso.dev is not accessible, upstream bug report, https://github.com/veeso/termscp/issues/420
  homepage "https://termscp.rs"
  url "https://github.com/veeso/termscp/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "cf3570c396ba36987059729f2704a88b87e4f154914062cf390b038694496be9"
  license "MIT"
  head "https://github.com/veeso/termscp.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "260c1a10e6efb3f42a0c8bb9783d3907ab5cd0b4342631df529e7c7f95be26c3"
    sha256 cellar: :any, arm64_sequoia: "18dbf7f1aa832ff2b6e180b012a974b35b651e1e45296c0389f5589166472c90"
    sha256 cellar: :any, arm64_sonoma:  "995f6d04555e31833c0507facf44510420f1d69a6a2e4e7604a4dfcdcbbb41b1"
    sha256 cellar: :any, sonoma:        "b9fe3904a4b6908bd27b5bdf286c1ae33df88add543eebd96a9f27406a2b6993"
    sha256 cellar: :any, arm64_linux:   "70cdd12281289e34fa3ed16bcfc0663799e765d1d08d6a412f98af1e38564ecd"
    sha256 cellar: :any, x86_64_linux:  "6edd3f383487972e4baed9e317f8b49ce307225f70b59f0749185cdca3190e53"
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

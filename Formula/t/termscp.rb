class Termscp < Formula
  desc "Feature rich terminal file transfer and explorer"
  # https://termscp.veeso.dev is not accessible, upstream bug report, https://github.com/veeso/termscp/issues/420
  homepage "https://termscp.rs"
  url "https://github.com/veeso/termscp/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "cf3570c396ba36987059729f2704a88b87e4f154914062cf390b038694496be9"
  license "MIT"
  revision 1
  head "https://github.com/veeso/termscp.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a1aa00689511a407bb92aededa05ccc8342a2b668b73c1bc2fb1405c4ae78719"
    sha256 cellar: :any, arm64_sequoia: "371b69fcb547e4e5840ce74d631b9fcb530f9886db59a5ef310ced4ba9356a7d"
    sha256 cellar: :any, arm64_sonoma:  "f54a5b9bae4d01919976d807edd02105ee39a48e49ece8a249e84ae85ef1e647"
    sha256 cellar: :any, sonoma:        "3e1e60e1f3569e7ddfa67984c2a6a880769a330ed40eb1c7b6fcd65e35533155"
    sha256 cellar: :any, arm64_linux:   "978de2068124bac2aacf04c4cb34707e9f3508771b1b3da34ec63254804d683a"
    sha256 cellar: :any, x86_64_linux:  "7bb91b296943f71c73036f4184583688b4b9237f89d7781cef8c302b0fc5256f"
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

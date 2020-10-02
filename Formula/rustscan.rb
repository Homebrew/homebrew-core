class Rustscan < Formula
  desc "Modern Day Portscanner"
  homepage "https://github.com/rustscan/rustscan"
  url "https://github.com/RustScan/RustScan/archive/1.10.1.tar.gz"
  sha256 "fe47acf9f0fdabfc5e260b0a28cde9349acb347c4214767f89af2dfacff55717"
  license "GPL-3.0-or-later"

  bottle do
    cellar :any_skip_relocation
    sha256 "9bbd788a689f80c4e725169032456f6978e50a5351bde8ca5ceafae7271d8d61" => :catalina
    sha256 "a9d0d7ca678fbe570150ce427b002ee0e84347dd8a5c29800645ac288f448a45" => :mojave
    sha256 "f4d1a2a3a887a63bc232a803af28d8a2c9c1f338063646aec0d73d5244471da0" => :high_sierra
  end

  depends_on "rust" => :build
  depends_on "nmap"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_no_match /panic/, shell_output("#{bin}/rustscan --greppable 127.0.0.1")
    assert_no_match /panic/, shell_output("#{bin}/rustscan --greppable 0.0.0.0")
  end
end

class Rustscan < Formula
  desc "Modern Day Portscanner"
  homepage "https://github.com/rustscan/rustscan"
  url "https://github.com/RustScan/RustScan/archive/1.10.1.tar.gz"
  sha256 "fe47acf9f0fdabfc5e260b0a28cde9349acb347c4214767f89af2dfacff55717"
  license "GPL-3.0-or-later"
  revision 2

  bottle do
    cellar :any_skip_relocation
    sha256 "4ac239e15d60ea7d0b2924e05f2e7d22a041843e0091926497df0475248a5d8c" => :catalina
    sha256 "693206c7d24539881ffe4ac09d9c65abdf9f82e7135ccffc64aa822c8ee35c24" => :mojave
    sha256 "9b94da615263e79c4cf64aa5dde3902b0056f9673d3b853e59340d95d55b01ef" => :high_sierra
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

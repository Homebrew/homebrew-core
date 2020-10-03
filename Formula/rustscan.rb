class Rustscan < Formula
  desc "Modern Day Portscanner"
  homepage "https://github.com/rustscan/rustscan"
  url "https://github.com/RustScan/RustScan/archive/1.10.1.tar.gz"
  sha256 "fe47acf9f0fdabfc5e260b0a28cde9349acb347c4214767f89af2dfacff55717"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "283697b96fff0a738e64581b25d86c8b3391b88887aea99efac96892d3d69e7e" => :catalina
    sha256 "0a98297ff385f5c18864a4b05f3b68323dda21fed87ab096a6c551b3bf4a81d3" => :mojave
    sha256 "9592dcac08be3079efb91c9b9affd9a297d2ff1d650dc01629ec77b7215669e0" => :high_sierra
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

class Rustscan < Formula
  desc "Modern Day Portscanner"
  homepage "https://github.com/rustscan/rustscan"
  url "https://github.com/RustScan/RustScan/archive/2.1.1.tar.gz"
  sha256 "51244a5bde278b25de030bd91e4ebe1d4b87269b2d0f7f601565caef4fb5749a"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ffa89393900fa09821ce302ca8100e3b2faa144633248641898f10f1835f8ae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f5e8433e240eebc01325acac2ed8605aeeb8f20d0e8b6ddaccdf850ef1c7176"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5953c9a05726eb6c2e4296ebb6be4e1f440fcba58d874838f5cab3233f663955"
    sha256 cellar: :any_skip_relocation, ventura:        "3dfcff3280f6fe5268ea39a88095acc38183eefff94fad38104fb9a7b84f5cdf"
    sha256 cellar: :any_skip_relocation, monterey:       "a1ff86e5c734de2d5ca9b8daff9b3cf6ac3a5f23c57586db4fa3aab59e0a845a"
    sha256 cellar: :any_skip_relocation, big_sur:        "406658263b1be14a072f5a2f3df599b4f4c9095c6890ac9785566b4d62015b67"
    sha256 cellar: :any_skip_relocation, catalina:       "aca14693bff909556d8ef512f239e1d373aa750d96275c75616c9b6f868b48a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dde072367d2ed2cc481eb26f495cf2f8f0931e37cb73b21c853293d6d0162f6e"
  end

  depends_on "rust" => :build
  depends_on "nmap"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    refute_match("panic", shell_output("#{bin}/rustscan --greppable -a 127.0.0.1"))
    refute_match("panic", shell_output("#{bin}/rustscan --greppable -a 0.0.0.0"))
  end
end

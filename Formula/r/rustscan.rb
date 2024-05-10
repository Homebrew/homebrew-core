class Rustscan < Formula
  desc "Modern Day Portscanner"
  homepage "https://github.com/rustscan/rustscan"
  url "https://github.com/RustScan/RustScan/archive/refs/tags/2.2.3.tar.gz"
  sha256 "6b2b7ffb070d4f1063e1bdbcebfc38d07cbd6c135b97bf027c870f43afb71c69"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2892a0605ccb2d23425ff9933027691ed872c22e6333dc68cab0f33358b01c70"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd425e735ba83220770cad3a401da58d3acb8a9231788250fa846057da66e7d9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8168f881920e51e08267c640bacd71e22366760c1f7a9d0094d8ed5a5b09e5cc"
    sha256 cellar: :any_skip_relocation, sonoma:         "63d9d1144a71bda348db83edc40a292018d49a748edccb3190ca846a93058a61"
    sha256 cellar: :any_skip_relocation, ventura:        "51fdca266b17480753b1d355391e4ec6ebead52b978e850c1a613a5ef833a534"
    sha256 cellar: :any_skip_relocation, monterey:       "cc108677c64cc635e80b41fffcd744ad64a61399c83d737a58c0cee3d79d51b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea93b0049be88fd506879f7b96837507d31d6b506fa11f3a66d11240ea53279d"
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

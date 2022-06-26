class Tofrodos < Formula
  desc "Converts DOS <-> UNIX text files, alias tofromdos"
  homepage "https://www.thefreecountry.com/tofrodos/"
  url "https://tofrodos.sourceforge.io/download/tofrodos-1.7.13.tar.gz"
  sha256 "3457f6f3e47dd8c6704049cef81cb0c5a35cc32df9fe800b5fbb470804f0885f"
  license "GPL-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?tofrodos[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "14175b3d27a7498f9efd5d9b1f582d0d961cc59ce8507a555f8cf2d24916c821"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "abd0c2470073c169d8fdbca2f0f65fe458da25456a8ace5758d394988d0f5ed7"
    sha256 cellar: :any_skip_relocation, monterey:       "da302a65bf5663a98627baef883a7a8c50413c7cc02e58be009d414f78011292"
    sha256 cellar: :any_skip_relocation, big_sur:        "11f0293ead8b99af5173c84b0e80cb63b3aefbddc6b411ce222f841383e8a4d8"
    sha256 cellar: :any_skip_relocation, catalina:       "da493ab6311aa1363533c8958c93ab919bee5ba26dbdcfa6f0a5978a6e512d9d"
    sha256 cellar: :any_skip_relocation, mojave:         "07d0fcc1ef5c69866787c61fc3cabafe08f873c111c22974758f1c4beae41f99"
    sha256 cellar: :any_skip_relocation, high_sierra:    "083975a39eaa51713f2eda153276ac95d8dfc1f038d25c4826be1ddcd540855b"
    sha256 cellar: :any_skip_relocation, sierra:         "3d5363cda2170ce2fbcb7e03c84f715b62ead1e5646000dd06395f5677fd2269"
    sha256 cellar: :any_skip_relocation, el_capitan:     "4a2b22ff08d0fb65c80be7359be2f04d12b70f4e6d490b96cb819ea69b3e3d88"
    sha256 cellar: :any_skip_relocation, yosemite:       "4a5427c6870c3d4822ef4da3ddd8d79c18b91e5b7f14edb4aa449a53da70114e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0f32616234ccfd1984a590ef37cd25cf15ba64fe0316f1f0a2d8fdea2cfc6f3"
  end

  def install
    cd "src" do
      system "make"
      bin.install %w[todos fromdos]
      man1.install "fromdos.1"
      man1.install_symlink "fromdos.1" => "todos.1"
    end
  end
end

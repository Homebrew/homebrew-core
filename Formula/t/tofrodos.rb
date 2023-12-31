class Tofrodos < Formula
  desc "Converts DOS <-> UNIX text files, alias tofromdos"
  homepage "https://www.thefreecountry.com/tofrodos/"
  # Upstream url does not work anymore
  # url "https://tofrodos.sourceforge.io/download/tofrodos-1.7.13.tar.gz"
  url "http://deb.debian.org/debian/pool/main/t/tofrodos/tofrodos_1.7.13+ds.orig.tar.xz"
  version "1.7.13"
  sha256 "c1c33f3f0b9e8152aa5790d233e8f1e8de14510433a6143ec582eba0fb6cbfaa"
  license "GPL-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?tofrodos[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0d43491486f1234740ab2ef86ade227755187108410addb1e81e30f7ca64ce80"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eeda32e08e9d8dca0de25bd428f85dd99c61a4fccf5ce0375558ed8cdf6f402b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "14175b3d27a7498f9efd5d9b1f582d0d961cc59ce8507a555f8cf2d24916c821"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "abd0c2470073c169d8fdbca2f0f65fe458da25456a8ace5758d394988d0f5ed7"
    sha256 cellar: :any_skip_relocation, sonoma:         "be25f46164831bf7df4dbe017f74bb5c4e831d839ef028a41f628c39bbe29947"
    sha256 cellar: :any_skip_relocation, ventura:        "34578bc9c2442a699ee9e4c45d6156ab574aa17d2a5fb7aca5487206adba1e5a"
    sha256 cellar: :any_skip_relocation, monterey:       "da302a65bf5663a98627baef883a7a8c50413c7cc02e58be009d414f78011292"
    sha256 cellar: :any_skip_relocation, big_sur:        "11f0293ead8b99af5173c84b0e80cb63b3aefbddc6b411ce222f841383e8a4d8"
    sha256 cellar: :any_skip_relocation, catalina:       "da493ab6311aa1363533c8958c93ab919bee5ba26dbdcfa6f0a5978a6e512d9d"
    sha256 cellar: :any_skip_relocation, mojave:         "07d0fcc1ef5c69866787c61fc3cabafe08f873c111c22974758f1c4beae41f99"
    sha256 cellar: :any_skip_relocation, high_sierra:    "083975a39eaa51713f2eda153276ac95d8dfc1f038d25c4826be1ddcd540855b"
    sha256 cellar: :any_skip_relocation, sierra:         "3d5363cda2170ce2fbcb7e03c84f715b62ead1e5646000dd06395f5677fd2269"
    sha256 cellar: :any_skip_relocation, el_capitan:     "4a2b22ff08d0fb65c80be7359be2f04d12b70f4e6d490b96cb819ea69b3e3d88"
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

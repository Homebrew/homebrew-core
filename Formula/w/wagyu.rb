class Wagyu < Formula
  desc "Rust library for generating cryptocurrency wallets"
  homepage "https://github.com/AleoHQ/wagyu"
  url "https://github.com/AleoHQ/wagyu/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "2458b3d49653acd5df5f3161205301646527eca9f6ee3d84c7871afa275bad9f"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/AleoHQ/wagyu.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "57802d359431dc4eefc7b5b38d70be730221ef164ccd327600e350eb9244465c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ddd3c15f7b61762da075af23b4139550f61109882648de03745dfb8ac859d412"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4a1163611ed4e907c5458922ca04ab13d6bb1c2f84b7de13d186f3e2f13ada34"
    sha256 cellar: :any_skip_relocation, ventura:        "675db40f0160e4dcc9910c5f1f511946620bac4403ce4ee5b92e97c991186f97"
    sha256 cellar: :any_skip_relocation, monterey:       "0a09ccc659885bddbe3daadfda30eff1a4f88bad1e2e4582567451013f855b3d"
    sha256 cellar: :any_skip_relocation, big_sur:        "c3deaea08b0f90132b84451b50bcc6fc5dac9e5cf540c2ef18c3c2a7ce61f8d0"
    sha256 cellar: :any_skip_relocation, catalina:       "af829681e853e2a146e256548fe69da9e55fde6d974f300b342754831749bd9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a81b1c07ee67f4e0cac9e8a7ca17720e440b40c14d66e76db3f5945f862eadb9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/wagyu", "bitcoin"
  end
end

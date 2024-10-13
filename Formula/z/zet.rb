class Zet < Formula
  desc "CLI utility to find the union, intersection, and set difference of files"
  homepage "https://github.com/yarrow/zet"
  url "https://github.com/yarrow/zet/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "792a1a1de73bf4145ccaa71f8e6bb34b62e690270a432c4de4d8639e1a741b5b"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "53c70e56c15f910f0da22bb3bc5203c5574ba2847bd79a940e6c0bec1ed98302"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5ad3c94f7c59db72d11e2443f81f65c81fe07985040da61df8266fbf0f02b187"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d5c53469bc92408c6554f1d2fe342752c54b038ce953a5b36b641973c1337284"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9e32e3a4567f0e85ca9cdb39089afd19fc27eb14e12c36bc4a398494cfe292d"
    sha256 cellar: :any_skip_relocation, sonoma:         "680526ad804b26e3028dbef1d6ccc7bf97dba1cbb5d184d57d3b9cb27ff71aca"
    sha256 cellar: :any_skip_relocation, ventura:        "0055f89e1ea739132aabddab22e2dd39318686938349b2f8682ccb3ac4c18463"
    sha256 cellar: :any_skip_relocation, monterey:       "5fd368452ffd4879a2eafa2d1c068551685ca79c89d7e82b82cee222d20c49fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77d31e1f9c755fed55bed70f31de9c61dced7aa03f178dd1d6f06bfb3d9a4b23"
  end

  depends_on "rust" => :build

  # rust 1.80 build patch, upstream new release request, https://github.com/yarrow/zet/issues/11
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/cbe90824d66a4c3a967ba6bda7806f8159534114/zet/rust-1.80.patch"
    sha256 "494881322c1e9f47b62b7e786d22e2d5ab1cc649021c7224f790e96f2b12c619"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"foo.txt").write("1\n2\n3\n4\n5\n")
    (testpath/"bar.txt").write("1\n2\n4\n")
    assert_equal "3\n5\n", shell_output("#{bin}/zet diff foo.txt bar.txt")
  end
end

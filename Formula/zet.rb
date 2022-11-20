class Zet < Formula
  desc "CLI utility to find the union, intersection, and set difference of files"
  homepage "https://github.com/yarrow/zet"
  url "https://github.com/yarrow/zet/archive/refs/tags/0.2.5.tar.gz"
  sha256 "82d369f3f2538f9d9f8e20b07ae0d26153714f71c9994aa96466ab3758ac1554"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b826c5f442fb71ffd28d466e4b08e9c5d3ed0895a87ff621cfa0aa3805b115ba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d21b66a48e85d1563067e7c3b390d148886bb93c631af00bb0eaa1e4430c7d7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b2f7d3a54ee2a0e490a97a455691c76442f3e5926f811b8bd5c18867f174e11c"
    sha256 cellar: :any_skip_relocation, ventura:        "25da5945db5b9276a1dc72f3b8c8f53844f5124cbc5eecafb497e85758ee2113"
    sha256 cellar: :any_skip_relocation, monterey:       "e60284b926062a06239f9467e1b58cfe57bcf5a340b744a2a2d745c7166c5b8c"
    sha256 cellar: :any_skip_relocation, big_sur:        "7abd5ab96d4fe4f518d843b12e3b6c568233c6a10407a09194ab54585be44d0e"
    sha256 cellar: :any_skip_relocation, catalina:       "c0d80bde9ec8b915ec1b13c198ea7ba8081d0980a080be9894467ce8b79ce124"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20a54cef3e368049b82cdb8320c31e9480be861f86681d34aeda1adeb1f976b2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"foo.txt").write("1\n2\n3\n4\n5\n")
    (testpath/"bar.txt").write("1\n2\n4\n")
    assert_equal "3\n5\n", shell_output("#{bin}/zet diff foo.txt bar.txt")
  end
end

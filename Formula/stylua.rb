class Stylua < Formula
  desc "Opinionated Lua code formatter"
  homepage "https://github.com/JohnnyMorganz/StyLua"
  url "https://github.com/JohnnyMorganz/StyLua/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "96a43de18ec7804b69453e6c4c4595eb343d4df2d41bd58746b4b0c34058a95a"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c800520fabb0b576262c4fbead43730747fff6f25d4a89506862009c2d7504f4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "630ddc02f136da94b9f064212e58375eab2640207ef423bde4848836bd65dd9f"
    sha256 cellar: :any_skip_relocation, monterey:       "e8efba5bb52394f926463920dbd85ec3ac5bce7e9b0f489b1cc4583b79a8dfca"
    sha256 cellar: :any_skip_relocation, big_sur:        "835f92db504cef1fcd02a333feb5dafe1cc2bdb4c127c88ec7b83232a1e28ef0"
    sha256 cellar: :any_skip_relocation, catalina:       "081053917d2a04867fb45926011036e9274f1d6cbf74dd4294f91273712db51e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e62e24cbb79b69f2c69a944467e7264f0cfcb2141d792137361bd90e871e013e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--all-features", *std_cargo_args
  end

  test do
    (testpath/"test.lua").write("local  foo  = {'bar'}")
    system bin/"stylua", "test.lua"
    assert_equal "local foo = { \"bar\" }\n", (testpath/"test.lua").read
  end
end

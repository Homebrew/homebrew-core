class Stylua < Formula
  desc "Opinionated Lua code formatter"
  homepage "https://github.com/JohnnyMorganz/StyLua"
  url "https://github.com/JohnnyMorganz/StyLua/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "198e54433b866b8d3a8934be3d1a0f4b40ac934621231be43d4aa2056cb66018"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f5c3ff1c6a206e465993b517c488698c9897143b219508aec6eded1d65e39c5c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ca23ac9d89ff3af8f204795c670b7e517968d56b242963439ddb30a28f8f04e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c1a2dd002f050516ca18138b4929becc084adca281f89122da5420758b2adc43"
    sha256 cellar: :any_skip_relocation, ventura:        "52b0fc7ba8fd1878e5eac31e928fd737ba0157a47e05c34e6521ea907893031d"
    sha256 cellar: :any_skip_relocation, monterey:       "b99ef98cd502fa8d372105ca99247835266f9d61fdc529fee6c7fd9dc7397c12"
    sha256 cellar: :any_skip_relocation, big_sur:        "171e1979c6ecf8f0c3bd8fb4b3c4ae58543f74f0507b86c29cc63ca96118afdb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90edb56c058bc3d7db3f82b8ed907af3e83e613a5e6c9b3f2596d87d2550ad67"
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

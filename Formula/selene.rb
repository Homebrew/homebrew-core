class Selene < Formula
  desc "Blazing-fast modern Lua linter"
  homepage "https://kampfkarren.github.io/selene"
  url "https://github.com/Kampfkarren/selene/archive/0.25.0.tar.gz"
  sha256 "e62c1328b1cb7ff2014a8419501a3fabaa87341a8932456283b53c148040e9e4"
  license "MPL-2.0"
  head "https://github.com/Kampfkarren/selene.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "feee5fdb67f02c32ab7afe87ea3f7a73338047061a029e6a58173955e49b8e39"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb83ea98bc1ebdc6287e08712447c66c9519e24ad6fc6f23eb8f1302cb0b82bf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "969f80f18b98d37031e1c1c85b4c21e74b54f31ec39c20a50feae9f43228e003"
    sha256 cellar: :any_skip_relocation, ventura:        "384992c4ae8547b8163852beebe45005d4c99f250aeacedaee45cbbc989eb4ae"
    sha256 cellar: :any_skip_relocation, monterey:       "feded6522fa99c1cc39e8f3c1f161416fda201b9991317f5ae60a25ca374f5ad"
    sha256 cellar: :any_skip_relocation, big_sur:        "8738fb84726af42535684ecea253aaa32bff32074f9c54e597cb7b83a17949f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "768f04c3bc90a8f028854a371e8c3a02602c3342a20d9ffa415b0daff61933e1"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    cd "selene" do
      system "cargo", "install", "--bin", "selene", *std_cargo_args
    end
  end

  test do
    (testpath/"selene.toml").write("std = \"lua52\"")
    (testpath/"test.lua").write("print(1 / 0)")
    assert_match "warning[divide_by_zero]", shell_output("#{bin}/selene #{testpath}/test.lua", 1)
  end
end

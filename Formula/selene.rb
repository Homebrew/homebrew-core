class Selene < Formula
  desc "Blazing-fast modern Lua linter"
  homepage "https://kampfkarren.github.io/selene"
  url "https://github.com/Kampfkarren/selene/archive/0.22.0.tar.gz"
  sha256 "4062413f6f07b8290d9fc9265436426980903a55cb034e5bf239284d099f3d8a"
  license "MPL-2.0"
  head "https://github.com/Kampfkarren/selene.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1392ed26b8b19295776c18bcf009efb1fc8f41a12688c93dfbe1e034b2ebd801"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d3f1b2ca8986d16dd9d81f7f9ae981e78f8d6f9e974306640bb0777d17ce4cbb"
    sha256 cellar: :any_skip_relocation, monterey:       "3cc0d4c9c717c4f6a89d400cefbec2a6a7cd5a1ef0af26aff052cdacdaa0451a"
    sha256 cellar: :any_skip_relocation, big_sur:        "506987d36f558afa039aa21b7e4187b6d147c33e7a2cd0365f3f66a9043f618f"
    sha256 cellar: :any_skip_relocation, catalina:       "8a6659c962779f1e63bbcc51ac28c8fd6338baaf3a266f659946805ba82d9fdb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa809b8d5b3cdac200184013be9ef7c9b453a54842ed0ae38b5b50ee8b671db3"
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

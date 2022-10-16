class Selene < Formula
  desc "Blazing-fast modern Lua linter"
  homepage "https://kampfkarren.github.io/selene"
  url "https://github.com/Kampfkarren/selene/archive/0.22.0.tar.gz"
  sha256 "4062413f6f07b8290d9fc9265436426980903a55cb034e5bf239284d099f3d8a"
  license "MPL-2.0"
  head "https://github.com/Kampfkarren/selene.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "96928adb367a3a67a942daebad8329de4fba5c87af534fbf438842142c11e777"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d832d34a72d9f63fb37fefc411ade62acebf13024713e227b2c77662704dbfd1"
    sha256 cellar: :any_skip_relocation, monterey:       "52f8b8dfaa3e5f5a36676846b7987904443f1346c9b09ea9f6957df79ef0147d"
    sha256 cellar: :any_skip_relocation, big_sur:        "69a0c9ada96537cf285fc36f036f72885994397bbce6ed484a511d642306ac13"
    sha256 cellar: :any_skip_relocation, catalina:       "3d89f2e77c7532f34c027b1a2748310d0f614f954b3010cd2b74641b18110d71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98958af9ff9fca6eb46b40d4d81e7a5ed83c63ed64bc81636cf5884ad10aabc1"
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

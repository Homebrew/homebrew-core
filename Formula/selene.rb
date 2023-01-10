class Selene < Formula
  desc "Blazing-fast modern Lua linter"
  homepage "https://kampfkarren.github.io/selene"
  url "https://github.com/Kampfkarren/selene/archive/0.24.0.tar.gz"
  sha256 "136700c26dff0fc1e6219fd089a0a98578dc00d681a8e4fd5e494466abcd3a39"
  license "MPL-2.0"
  head "https://github.com/Kampfkarren/selene.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5d95be9241480da5df334b2ce9696ab3ba866914a40eb4062bcce617daf766fe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ef5c7d128d1ea680c6655c57a4a1d207a6e46f92f0792868d04290d0325761d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f85731dfa5fde4493c08e5bab2e9c6a834e2031ccc61426c12152cf90955a00f"
    sha256 cellar: :any_skip_relocation, ventura:        "5a1c4e6cbb9b86202fb2a59eaf7160ece66bc92ca1d7436e15c302c88171a19f"
    sha256 cellar: :any_skip_relocation, monterey:       "53d4461db8bf4ded8a1479f29174455a7fe410d138fa70eadcd63007402eb091"
    sha256 cellar: :any_skip_relocation, big_sur:        "40cf3ff39e790e08c98ec4de2261bcd185c9acc69c6a7668ebd3d930f719b337"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "055239ce600acdca3518958fe9ee227fcc96c9afc2031f549b2a18608183b39c"
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

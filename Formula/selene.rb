class Selene < Formula
  desc "Blazing-fast modern Lua linter"
  homepage "https://kampfkarren.github.io/selene"
  url "https://github.com/Kampfkarren/selene/archive/0.25.0.tar.gz"
  sha256 "e62c1328b1cb7ff2014a8419501a3fabaa87341a8932456283b53c148040e9e4"
  license "MPL-2.0"
  head "https://github.com/Kampfkarren/selene.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "74278a032b89a8f0d28b1a8285287b78e773f1d31a02afe61ca0b2b249df785c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1756d3883eaebf1458f83e19b46421e3e6de79e7bf86b837b52d07c5f2497991"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "87f0bd65aa6d219360e5797411c3c311230871ba47563e97b44dc965432d0420"
    sha256 cellar: :any_skip_relocation, ventura:        "214e7e9b9f665f860288096461e317f91d9e0f0cacc6a220cd64d2b894c041ec"
    sha256 cellar: :any_skip_relocation, monterey:       "0d27b771f6125c46ba4ed88981aa77eddee67d535450bfb4d38344476253c564"
    sha256 cellar: :any_skip_relocation, big_sur:        "3884763fdc134be0d358f2b9d4cfb232d0f50c8d47ced03ace9faa4414cb8fe7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6c6c4712887a6f7fab3d7c4a7c63de817b699f7c2f6eda7ea759aeb13c7a27b"
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

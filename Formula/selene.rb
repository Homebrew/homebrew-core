class Selene < Formula
  desc "Blazing-fast modern Lua linter"
  homepage "https://kampfkarren.github.io/selene"
  url "https://github.com/Kampfkarren/selene/archive/0.18.1.tar.gz"
  sha256 "34b886e0d616f54277f434918e0ef6003e987eb12495ab2217477678fa53ac2c"
  license "MPL-2.0"
  head "https://github.com/Kampfkarren/selene.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "06cfedcd6c3fb683b2a1062b20355f57f3118dcea3f144c052aed1460271d8ed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eb089ea912aba98806bd538400d08e1283d941d019e420da41d90ba63c86096d"
    sha256 cellar: :any_skip_relocation, monterey:       "369409ce99cdaa34f6d1c9a7c59efdbb59ba385647452fc8f3ea5c81584ebf34"
    sha256 cellar: :any_skip_relocation, big_sur:        "0546da89cc5c0f3dfcf78a97bd946d698024d35975b0592ca85a67cc0ed57f5f"
    sha256 cellar: :any_skip_relocation, catalina:       "3157695295d27b94fbfe3b5a4108761094c008711bef6bc2c2f8a8159abbd207"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d74e56c2fb217d7d843f9b2c4f296c09c29974a5fa82d52baee1736a2595e0a"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    cd "selene" do
      system "cargo", "install", "--bin", "selene", *std_cargo_args
    end
  end

  test do
    (testpath/"test.lua").write("print(1 / 0)")
    assert_match "warning[divide_by_zero]", shell_output("#{bin}/selene #{testpath}/test.lua", 1)
  end
end

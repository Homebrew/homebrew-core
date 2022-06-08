class Selene < Formula
  desc "Blazing-fast modern Lua linter"
  homepage "https://kampfkarren.github.io/selene"
  url "https://github.com/Kampfkarren/selene/archive/0.18.1.tar.gz"
  sha256 "34b886e0d616f54277f434918e0ef6003e987eb12495ab2217477678fa53ac2c"
  license "MPL-2.0"
  head "https://github.com/Kampfkarren/selene.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0162f72261176fc54c0552ae3ba936f4588e82b850731f6296663ceea579613e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2101515e66d5d34423c3d01eb6e033d7082449a440f138a705441a727b409754"
    sha256 cellar: :any_skip_relocation, monterey:       "65c7962577286fe23734e610d2a0726ea3fa77f276e278bed4f12a5e93e72633"
    sha256 cellar: :any_skip_relocation, big_sur:        "f09e0812af8af8c466ac98d6335a08c058cd2fb762d70d5192fb96fb86265583"
    sha256 cellar: :any_skip_relocation, catalina:       "2dc538237e70e67d380f2415be246c6a7a4378337114f44a651b3232d140ac48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8efc495a9ca23c5ff34245c91f99f36bbfa58cbd75a6e064ec688dd284fb50c0"
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

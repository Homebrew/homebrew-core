class Selene < Formula
  desc "Blazing-fast modern Lua linter"
  homepage "https://kampfkarren.github.io/selene"
  url "https://github.com/Kampfkarren/selene/archive/0.19.1.tar.gz"
  sha256 "c6a98dda7e0e4d4fe5d310560520136ae9deafc53256de130ef0228b2b367cd3"
  license "MPL-2.0"
  head "https://github.com/Kampfkarren/selene.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3243f618683b7eb04915ff5c7130089f047ba54db390f845e36df69151a494c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ef1d51d93cb2fcc885f160b20fd7174f601894443b66d867433ef771176948bf"
    sha256 cellar: :any_skip_relocation, monterey:       "4ff395f7d862d6f6e644fd5c474aab726cff50f2ea60e4ee352e417e4a67fee2"
    sha256 cellar: :any_skip_relocation, big_sur:        "0193e12ffb22a0a41be67d33f5d7a829b938684fa908f4d7cdbe14de6648d118"
    sha256 cellar: :any_skip_relocation, catalina:       "5da4123d198679d79ab78af00ea71ace066f596a591a9fadba1cd1441d3bbb79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44981ebc20284330014a86a5dd85bf31fbf29454947bae84b255a93e708bde6c"
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

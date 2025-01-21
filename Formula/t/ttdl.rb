class Ttdl < Formula
  desc "Terminal Todo List Manager"
  homepage "https://github.com/VladimirMarkelov/ttdl"
  url "https://github.com/VladimirMarkelov/ttdl/archive/refs/tags/v4.8.0.tar.gz"
  sha256 "ef0871ecd8359b25c70b1e01263d3149a334c7aa681b1701dc78f887adfe819e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "310ed73dd97458e9582cf7b47cacc6737609bc5579e02cd39c70c28b7a25575b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9447066c01a026fafda2e8e863339ff3cd1e42867b48ffb70c9a69f795a3cdfc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b4e2cdf9baa4fe94e56a1aa6abd68b9fdf2a641b7297567371161d3b73dbdd4a"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8484cf50fb0758d99b41b85e861bc2f77834ef7316b20212c24b2e5aee22945"
    sha256 cellar: :any_skip_relocation, ventura:       "28f6c65b4b6ca264d380e3209059097263095f6f5344aa9897b618ed64d07a87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf81a77cf6e1caab398bb5b1f3eddaf5ef048d3e820a3491109e58044f48f831"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Added todo", shell_output("#{bin}/ttdl 'add readme due:tomorrow'")
    assert_predicate testpath/"todo.txt", :exist?
    assert_match "add readme", shell_output("#{bin}/ttdl list")
  end
end

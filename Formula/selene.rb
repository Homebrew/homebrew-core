class Selene < Formula
  desc "Blazing-fast modern Lua linter"
  homepage "https://kampfkarren.github.io/selene"
  url "https://github.com/Kampfkarren/selene/archive/0.15.0.tar.gz"
  sha256 "c6acce7207235924bb65e9897b229d6a904f5f7f7ef43a2a02ae4690551eae16"
  license "MPL-2.0"
  head "https://github.com/Kampfkarren/selene.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77f3b05dbba2541abd3c6e68080dd063ade95a516986e90944186b7c0a9b189a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8ee0c7b082a27b6ba4f340e56fa5155b19820a70b559befea0f2aade51fe4a3b"
    sha256 cellar: :any_skip_relocation, monterey:       "0423ac9a94646713c6011117c0039d1d8ad3454bfb6234674787c3cb19682f7a"
    sha256 cellar: :any_skip_relocation, big_sur:        "5c88363d87b5b92366e4f06c5cafd4ba5a4b5a40d910fe89fab1c9cffbe8968c"
    sha256 cellar: :any_skip_relocation, catalina:       "5c62786dbafe6f0344bb2a31025a04ac63b30f088215ab55fd49130e95bbad08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5501bc2e2f231c1b5b45fabb41f01e8c28fff8d48a0413f8e40e8e90723b05e"
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

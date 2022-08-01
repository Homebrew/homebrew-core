class Selene < Formula
  desc "Blazing-fast modern Lua linter"
  homepage "https://kampfkarren.github.io/selene"
  url "https://github.com/Kampfkarren/selene/archive/0.20.0.tar.gz"
  sha256 "ff37af1ef978ff66cd77d03396185b8abcaacb9860f1f1195d01325b4874cfd9"
  license "MPL-2.0"
  head "https://github.com/Kampfkarren/selene.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3089f1ac9c711c75ecf87bfbe94948f07d7e4b95e7cbdd983968b793ef54dbac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "17837ac8aed77cfd5c2e6cfd38ee3a99d3ad39ec2ac6b074285e047d79fb7349"
    sha256 cellar: :any_skip_relocation, monterey:       "3d8a38fed935b360db70cc4c14f1cbdd91e6b6c52ba18452d8b737f485b4e8de"
    sha256 cellar: :any_skip_relocation, big_sur:        "57fff5a246bd2384265fb390c9ef0868d81628cf248ba0f33fc91a701593cdb1"
    sha256 cellar: :any_skip_relocation, catalina:       "eae5820d0868ec5399b8a3e9d9cb3fd7b652dd2186bb62f836b6352f9be32fd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "643b8e4181d3759777baf3c9005e615883fa6c9900f7e34f022633031df140c8"
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

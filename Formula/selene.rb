class Selene < Formula
  desc "Blazing-fast modern Lua linter"
  homepage "https://kampfkarren.github.io/selene"
  url "https://github.com/Kampfkarren/selene/archive/0.18.2.tar.gz"
  sha256 "16401ee92f0df8d6384160110c5f30e5935b4cd687a6d24de4e744278223ce30"
  license "MPL-2.0"
  head "https://github.com/Kampfkarren/selene.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1dccbff01054da1173b3a0f2b5fdd6ba31c20cbe045d74a092ae3dc885e8d2bd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f6fe88a184e07a336f03eef87ca4f494ca856fd98f61bc1033fda9dbf0aea14b"
    sha256 cellar: :any_skip_relocation, monterey:       "132a173f19b8cef4a6e58464689bb04aeee1bd756a9e87a0ab53e86843671e24"
    sha256 cellar: :any_skip_relocation, big_sur:        "f1e2099730160c4149d39200ea22ef232b49c230a8a8bcd431a4af25d7da4d18"
    sha256 cellar: :any_skip_relocation, catalina:       "d0c6caea65ae5908ba645a0b77ab1f2c27689edaa2058b202de0e799ea809285"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39347deaf3e21e6563c31548d16657b1b32664d2833b59ef4722e531caa5f7c0"
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

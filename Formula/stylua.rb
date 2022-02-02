class Stylua < Formula
  desc "Opinionated Lua code formatter"
  homepage "https://github.com/JohnnyMorganz/StyLua"
  url "https://github.com/JohnnyMorganz/StyLua/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "f9f57d52a5665c4c878556e14b8533da053d64a55575fbc92e4445c5a064bd4f"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f49f7c846adbb114de153972dabda9fb76ac252ee834c17d04258c89ffcfd89e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "affba379fc7c96ed0a080a51706d0890ffd238cfa05309dd6046b0885f2f34e9"
    sha256 cellar: :any_skip_relocation, monterey:       "8fde6d6df91fde7d1a093ddf84964147bc2dc72d36c048f65db052013d5bec48"
    sha256 cellar: :any_skip_relocation, big_sur:        "117e847bdd6a167e779d16e8f71a3ba249e4e66d7d0780ab045cc8863460807d"
    sha256 cellar: :any_skip_relocation, catalina:       "e9aca6e6f6799936e189dc4e8a74a0e37931902a5dd1c87da52fd02a3ff5701f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b35962d8c3e539d2253b2722d3fdbf6a608b50451b43442a105b3954b5392e08"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--all-features", *std_cargo_args
  end

  test do
    (testpath/"test.lua").write("local  foo  = {'bar'}")
    system bin/"stylua", "test.lua"
    assert_equal "local foo = { \"bar\" }\n", (testpath/"test.lua").read
  end
end

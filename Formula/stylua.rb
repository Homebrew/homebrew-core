class Stylua < Formula
  desc "Opinionated Lua code formatter"
  homepage "https://github.com/JohnnyMorganz/StyLua"
  url "https://github.com/JohnnyMorganz/StyLua/archive/refs/tags/v0.12.5.tar.gz"
  sha256 "7475830178297c56a7048eaad8fe9ba34f9e62fa7e84929793f6d6e73896c676"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4663207d7f50df3ef5d819387b321d7be609b2ef19eee6a2693da7ccc8558bc8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ced7d722cf0c516992c81705e2b8bb25d21287e208dc57945c10b74aa83a4a13"
    sha256 cellar: :any_skip_relocation, monterey:       "8df0fa9eba71b9147c2055befc49dca8e77809dac20997cf22505821e432d0b4"
    sha256 cellar: :any_skip_relocation, big_sur:        "5670a31cc24c480aa82e77b353802343b2d75cefb2d5cf204ab29731306041b6"
    sha256 cellar: :any_skip_relocation, catalina:       "513b869261a1a9c50c131a3aa4b3b916e98c52a06209547bb2e45c4f55e977f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e83a027df0e6ab04c31ec679d4d57cbbe4178682c11cb2f272ddedda3d87a68"
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

class Stylua < Formula
  desc "Opinionated Lua code formatter"
  homepage "https://github.com/JohnnyMorganz/StyLua"
  url "https://github.com/JohnnyMorganz/StyLua/archive/refs/tags/v0.12.3.tar.gz"
  sha256 "c7c960d501535329e007ff9757067d40b0cf395c2fceac09e169f4c9ea8e67ca"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7309025bfe5a942d6995e65d9bbea7cad8ff40a2c529f24648d0e7158e09b8c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3f4cbff6f754f59a2e91a4fd3355adaf1c07b1fba01f876c6c11d3707e13993f"
    sha256 cellar: :any_skip_relocation, monterey:       "55f71c3effcc3c4a63e1da16d5f9c2ec8a1c6d58f8db14eb7805b43f77d7f600"
    sha256 cellar: :any_skip_relocation, big_sur:        "6a2f4be4b6ceab43cb994747ca874ac5da279acc1773c65fccd82a0d34175dd9"
    sha256 cellar: :any_skip_relocation, catalina:       "3f5e35ad07c200b320a2e77cfc788ea48c8d753fb6c8d7eac6dbb13df209d345"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "687f02bb4522c03912f0b9bb96584bcd8a76154a90a76c5eaf0da8ba25303a0d"
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

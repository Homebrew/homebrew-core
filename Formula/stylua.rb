class Stylua < Formula
  desc "Opinionated Lua code formatter"
  homepage "https://github.com/JohnnyMorganz/StyLua"
  url "https://github.com/JohnnyMorganz/StyLua/archive/refs/tags/v0.11.2.tar.gz"
  sha256 "e870551aab62194b92fcb73607c7b7f6e4a41ad75a64e67f18e5ce0a6c608573"
  license "MPL-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "57a748c0078fc6f15f40e860293659c8e828b01c273863ba6da6ebaed41c3f23"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "85cb2222d80dcd4f9511100c9d80f2c839a750361f1efe01305eb53aa2334e5a"
    sha256 cellar: :any_skip_relocation, monterey:       "e0119b9482d6041cea2d8fba186f70f2c0076f2ba34629473e3d354965b74346"
    sha256 cellar: :any_skip_relocation, big_sur:        "6b8208cb46bd0d211fa8db24072890cd2d8e6274dcdd0f415715617d8763205e"
    sha256 cellar: :any_skip_relocation, catalina:       "45ddab73dc80dee2752ccfa738b40bb78a925b943ebbc488c1b37a5c2273b741"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e74dba9ed14d9f4552bbace974c0375060c01c675211965d5182f8888a87fc7f"
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

class Stylua < Formula
  desc "Opinionated Lua code formatter"
  homepage "https://github.com/JohnnyMorganz/StyLua"
  url "https://github.com/JohnnyMorganz/StyLua/archive/refs/tags/v0.15.1.tar.gz"
  sha256 "5524e431a1805b7cf43587f16736643c75a00092bf302bb1f9f73e8e5d1c5a41"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f6020f4f5f2e4301b89d5bce913290d5b6c11117507b9a986e7c0fae9583a216"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b3ed25dae47d35ab3da32da4e747c6421799c88515c634ead6f3e7498532928a"
    sha256 cellar: :any_skip_relocation, monterey:       "5311223f3ed73c1533708317f9ed4591dfbbf7c14747a99be421d7d31480d4a9"
    sha256 cellar: :any_skip_relocation, big_sur:        "3ff68463132b75937a97799474c893d27260b014b2f443df72c23517597803a2"
    sha256 cellar: :any_skip_relocation, catalina:       "c932ecaed5128b9c6b4ce8a31b9ab28a0ba04b26ed2cfc5b758a415cb4093358"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "613fe093b4645169dd829bf31547cc2f89f57dbf699cf2c4c9f1712c9a6dfbb6"
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

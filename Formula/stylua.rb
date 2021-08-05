class Stylua < Formula
  desc "Opinionated Lua code formatter"
  homepage "https://github.com/JohnnyMorganz/StyLua"
  url "https://github.com/JohnnyMorganz/StyLua/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "dc6077fe23f57e35173032e499870548ccaa3894df1caf4db4cfc9451fdedca4"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6ce4b2a7a2c1977c9ebcf03a9ec6cafb6afcfdd9cd590a59a3fde3e5fcbff57b"
    sha256 cellar: :any_skip_relocation, big_sur:       "6a1a45e829958d8b3f1f9992fccef2814e732b7b8324036116042de0cc5acac3"
    sha256 cellar: :any_skip_relocation, catalina:      "13ae844c547ca3128225a48fce94054233fe582e28e6965c21eb2f6a1fd7a990"
    sha256 cellar: :any_skip_relocation, mojave:        "d936a87e226a5eb7d4ce55cba07cdbe9ced0e6eec83ad8858d1309655a6a4340"
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

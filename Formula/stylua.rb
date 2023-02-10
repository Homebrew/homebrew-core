class Stylua < Formula
  desc "Opinionated Lua code formatter"
  homepage "https://github.com/JohnnyMorganz/StyLua"
  url "https://github.com/JohnnyMorganz/StyLua/archive/refs/tags/v0.16.1.tar.gz"
  sha256 "a16fe46ee0383c6f37b02f37d2cd80d7c1866defa01446f086258f26d6372597"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b745c7f2890b96d722bce4d75b52aaddba96eadca4831e406550d0971aeb1dcc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab13db4a57f094cc9703d56260d77d2c8cc515029735ca48b2395af8d5c3c2bb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5f6d295269e6c8e4ecc9a9559c462e026ce87b948cfd0c7462888537b90d40ab"
    sha256 cellar: :any_skip_relocation, ventura:        "fe47865c756b2b23686690da3e9d0722c28b1e1a79b090274668f5df1f990917"
    sha256 cellar: :any_skip_relocation, monterey:       "81ce033514e128128b8200d0479c8c7dd28f4a714e6237081df362e81880cf9d"
    sha256 cellar: :any_skip_relocation, big_sur:        "fadcd3572ff3acfb3b8254a3c49204f2675be321fbd7111aca8b01669e3f5f7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81f37d0f8f0df9adc7947ba61dc6d7eab3984a80c0b614ead0fa9f6bc44cd9c3"
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

class Stylua < Formula
  desc "Opinionated Lua code formatter"
  homepage "https://github.com/JohnnyMorganz/StyLua"
  url "https://github.com/JohnnyMorganz/StyLua/archive/refs/tags/v0.18.1.tar.gz"
  sha256 "e06bd0e2befcfebfa312930f282acdc6e2cffff7c1cabce648be4d88e7e5f7c0"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8fe4df5883d0e30e743b8ca50f99b10ef7fb17e1367f6de340a482e6f3bb7a8a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98b62a18dcd8c00a4e45d277511fabb0e80424e0cd21e9b9405722abd5c66c53"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "103d3e62872a1284baa00508eb6a0955f6d61b03a495debf49d8bdf9ae7b050d"
    sha256 cellar: :any_skip_relocation, ventura:        "7db646947b6a9b3ab9ea281a2394c6a1a47b4e513a16fa4072a1add80d9ebaaf"
    sha256 cellar: :any_skip_relocation, monterey:       "ff5dc0941de18dc55652bc91f1303831a9b90ca4bf491e12a9866583059a211a"
    sha256 cellar: :any_skip_relocation, big_sur:        "ff3457d9416296e4f7dc8dfa5c8bf4b211209a40e14f0adef072b1686215fe50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4273919d452cae6e0a851f697748827e9d398a1823af2b466d4efe4cc98021f3"
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

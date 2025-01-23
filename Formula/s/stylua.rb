class Stylua < Formula
  desc "Opinionated Lua code formatter"
  homepage "https://github.com/JohnnyMorganz/StyLua"
  url "https://github.com/JohnnyMorganz/StyLua/archive/refs/tags/v2.0.2.tar.gz"
  sha256 "0d88a55d4d33a7d7334bdef8ccaf1fb6524b21dd66d60be8efc0cf92f6d31ad3"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "100ea1d9bf00991a49e001e172ae0c24eaf001a9d00c6e6c4550bf4300101c68"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61dea5a3b62c2750d8d2fef2cc6cdd5db85ed163f529e04c0cb5faf0147dc8f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7497e794f0528237ecbff7659cf4854f4e86e347daf80a3f822e2b3677cd073f"
    sha256 cellar: :any_skip_relocation, sonoma:        "b0a1025bbc3bcc29935b2a57df110dcf93ef03c801f194a8a0cff700c9c21ede"
    sha256 cellar: :any_skip_relocation, ventura:       "d61f30e4262a33c0503d92b2096ec308219c035d01025ddc3d8d9e0df56a9ad1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7710b308ed755149b08e254d8a5670198ceae18a9655f3914d201d9343d918c3"
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

class Stylua < Formula
  desc "Opinionated Lua code formatter"
  homepage "https://github.com/JohnnyMorganz/StyLua"
  url "https://github.com/JohnnyMorganz/StyLua/archive/refs/tags/v0.15.2.tar.gz"
  sha256 "9a0ce0131f0fa38652f03281c54de0c6e3251e06897a53d719e78449d66e270b"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d5ab6058e0c316cd0be6504c8d45575cfb9f37283e04bf29f2eabdb679159e12"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "937085cd26d6227992b78f76e83f4d45e9aeeae49d8ca0e0e204f75648694e3e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3d93baf9e4c19fd8554313f8a3f9d4b9729a2b7414f9491e73c89f4a407c62f9"
    sha256 cellar: :any_skip_relocation, ventura:        "61f0a0128ae1c8f9cc21d43df0e7f24c8f57a751dee58e2707e2626a7f28061b"
    sha256 cellar: :any_skip_relocation, monterey:       "108f3dc74d78f51cf2189c04e189c8ba6d75439e5b7dc1f57c4472b17ee9e691"
    sha256 cellar: :any_skip_relocation, big_sur:        "b54f262cd9cc5c72624d1aacd8ed10bba2eb58066755fcc37d73f6686a50abad"
    sha256 cellar: :any_skip_relocation, catalina:       "c3292b0eee208df618ce6e0e8f6df3d6faa693e7fb596e834eee5a6a13307fdb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5cacad1160921fc9acb1d8fe8a267d5bbe1ab87a060276fc79827d0857ed156b"
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

class Stylua < Formula
  desc "Opinionated Lua code formatter"
  homepage "https://github.com/JohnnyMorganz/StyLua"
  url "https://github.com/JohnnyMorganz/StyLua/archive/refs/tags/v0.18.2.tar.gz"
  sha256 "25a81ffaba54479ca7ddaa6ebb7611d60f8849004b5d6c50ec1b31edb2295c8e"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e5aafd3c0c7350a4693d53ef1a072ab23b18a16ecbbd3878837a5554f9a62c29"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c23d73fa348162b7b024c6b25d7ed03520da64c2c77180c6a98b055c11432d9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c8f9f250710e3770dacc58d48be88aa42d44c4842b7ac9b4b226304d60dcb079"
    sha256 cellar: :any_skip_relocation, ventura:        "df8883cdd97203c2200a1271a76234ea0c2ec2b78af48c58e285e1dcb2efa8bb"
    sha256 cellar: :any_skip_relocation, monterey:       "5dc1b41e33c7162d4406eb0ff2f3859bd619701ea0a6a072280ca476d46d7330"
    sha256 cellar: :any_skip_relocation, big_sur:        "0ee70c9016f249ee808f406d32911d976344855ff1f0b5ef7076cb8ea4cc2f32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77b4a590aa2dffa173231fdd8fc430e140b3b3b1e9b9c543c69f0a6bfc0eea2e"
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

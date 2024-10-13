class Stylua < Formula
  desc "Opinionated Lua code formatter"
  homepage "https://github.com/JohnnyMorganz/StyLua"
  url "https://github.com/JohnnyMorganz/StyLua/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "f4a27b12669953d2edf55b89cc80381f97a2dfa735f53f95c6ae6015c8c35ffb"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "9fe715f0439091c568f7ed188668d37a203dfaf761f3d37f65753e4d2eb05156"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9ed3a64c2458dc6a1202dadd20978ad67ff1ed683d401c3a20eafbb897cc035d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "961c31cb07618a28e0f693eb2eca4f2796015273cccb09de8d7f3ac0084e6b27"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a89dbeb4bbe0d8990bfaaa8a6920c116bc242184c64b73e2bc4b7658fa0b16bc"
    sha256 cellar: :any_skip_relocation, sonoma:         "57ecca22c43085d553368c606dbfbac58b239dbd7cad368dc04d5069c6f08e52"
    sha256 cellar: :any_skip_relocation, ventura:        "6d4937c5fd1b291ef802f6c47492ece4507d114ad65f845e44b14fc16e17b74d"
    sha256 cellar: :any_skip_relocation, monterey:       "29f04a3f58c57e1cf185a40092a0b1bd66769b58df171e2d63f91ae02db9ee4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c02f4e0bacb23acf879bf1ff14e8bacf6a7b2a5cbb6a649337bc271106e0e25"
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

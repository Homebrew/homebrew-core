class Stylua < Formula
  desc "Opinionated Lua code formatter"
  homepage "https://github.com/JohnnyMorganz/StyLua"
  url "https://github.com/JohnnyMorganz/StyLua/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "ec659abac6dbe18b7ac0d53e830ab7a14805b389aa0ff97c06cc7fbf3f341292"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1de151ea9379d59e93267708a881ca6899add6f29809ccbab8ce8bbe82c0331b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "688913cb547f8c8f0e692b58cefcacddd0f21d45e889955f2e904a2b00140622"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7c2024d46b44df773f7db1a0388ea9602132fc34a6cd2a7ce49d2c19a17ca630"
    sha256 cellar: :any_skip_relocation, ventura:        "3f7f25c2f9bdbb8114a612640a9e17fe668da5340cf0e9b4ddbe63f6abc7d44d"
    sha256 cellar: :any_skip_relocation, monterey:       "354765e34347127069fb2e536f84b57d0360c78ae9273c77c87f1b360cc0c04a"
    sha256 cellar: :any_skip_relocation, big_sur:        "fee027f55979da6484bc081a0cae72aeb41730a65738bf9a167615182aa61a97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "828d4c09a1b5c88edf7dcae000b510d17ef9c21032dfe14aa4ebd9ff258471f8"
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

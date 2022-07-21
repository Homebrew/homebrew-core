class Stylua < Formula
  desc "Opinionated Lua code formatter"
  homepage "https://github.com/JohnnyMorganz/StyLua"
  url "https://github.com/JohnnyMorganz/StyLua/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "8e00c8e0ceae668562e7f8093fb1a1b6c96128e3b4d4b1060b783821998c0d0a"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9218cad628d9a96408d374f6401b63bbbd6f8463e4eb48b8014f68bb9f35aab0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1c7e188d31a3a487db74ef1e17b458601b09d3e48a71752b17bcec9674b5d054"
    sha256 cellar: :any_skip_relocation, monterey:       "547b3297fac2db92bed0ad90e77e1778deef49456772080d4f47ef2c9e0c9472"
    sha256 cellar: :any_skip_relocation, big_sur:        "8044b02db3575f59ffaeb2b4817caf4a84430518552943e925af56fb275bd648"
    sha256 cellar: :any_skip_relocation, catalina:       "d1a29d77ade8b65f284e0830d40ee5d5eb739667ebfc8a8a0c9a709900aca008"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eeea0827c868532030ca04bdaa22b551944997b37d26f8d64b050fbf91382fd7"
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

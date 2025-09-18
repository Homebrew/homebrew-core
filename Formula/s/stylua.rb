class Stylua < Formula
  desc "Opinionated Lua code formatter"
  homepage "https://github.com/JohnnyMorganz/StyLua"
  url "https://github.com/JohnnyMorganz/StyLua/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "257863316696fcb868186254c47cef54f80343c66a8bf1430cf24f35add0a475"
  license "MPL-2.0"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eda2b1d3ba07ac901b4a56227852338f08dc9b93a825048205e18b73ef6bd542"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1900600da0fba318cb8c9160f00f509e25c2110b58bf5ae7bc95f3655c0d1b13"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "143a81087de47a92c02c6cc5defa03bce510349f53ca8338831d2b176264fda7"
    sha256 cellar: :any_skip_relocation, sonoma:        "b314307b6786f249bb78ca539b73dd45171d8a1033341d6d0bfe1c5dfde4c9bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "623721c0724c51963b9239affaffb2f527c206a4837d2c9fcb8300a995dced8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa602e46ab72f3401a60f9740f3a772527e8f3197284adf6d3952116242b6ee4"
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

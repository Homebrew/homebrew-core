class Stylua < Formula
  desc "Opinionated Lua code formatter"
  homepage "https://github.com/JohnnyMorganz/StyLua"
  url "https://github.com/JohnnyMorganz/StyLua/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "eeca8de825f7cd550a846bb2b0c409f112e8f16fe007863996cc49ca4b9641f9"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5cac08145d9bf7e5041b51bdb178656cc4f15b5c1d555057bf02554a014cae98"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79bbf43376aa36eb8f798fde745a2e011efde94157ed9b8c957f61a22692e406"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ec0963645a2459ed16b34550edfc97ad830b88ee90b7d5840ad761fa1cbb947e"
    sha256 cellar: :any_skip_relocation, sonoma:        "1cd2e9825ff467a29740088973d4be7b2221ddeabc58fc6a1ed13cc5048e9ea0"
    sha256 cellar: :any_skip_relocation, ventura:       "e5e563eb5db649aaa7682149254131d1bc80f52c400ebed3fd29ecdee60b9b7a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9de2f4882cb9315a3cac3184f0909e341666863718eb4951850de5c9fba07329"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed74a1be8b98454ae54fac27dfdbba2437dd8ef89ccb55ce2b88eb54d36dd792"
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

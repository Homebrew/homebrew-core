class Stylua < Formula
  desc "Opinionated Lua code formatter"
  homepage "https://github.com/JohnnyMorganz/StyLua"
  url "https://github.com/JohnnyMorganz/StyLua/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "a42305c175e44c87f4d3c210e7b89d499d81053b48f4aa05bde841a3702ef07a"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3b4f22257cdb40e1ea3db011f637ef702865aa25b2201283e53a85f3096ac302"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a2a7b9bca1198a01b063924f3c197ccadf02e21628ef639a571fc169e886661"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1a2e5fa360cb3c5fc5192807c10f263996b36ba48ba206121967190c0d81777b"
    sha256 cellar: :any_skip_relocation, ventura:        "13c9ef097c8728a3018adb5b8fc54b3e83f6da61e04221727caf3520c5468ad6"
    sha256 cellar: :any_skip_relocation, monterey:       "5187b602496a8a9f035d529af7ef47a9d1d9934453935290951c0972a1a251da"
    sha256 cellar: :any_skip_relocation, big_sur:        "11b955a60ff0dfdeb10588cbe6ab0d77f472e32a7dcb72c2230785ed90fcc09e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3edaa9a74c62c413952edb57d5bf98a7a3543fd4801aac68d7606c0de2757e4c"
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

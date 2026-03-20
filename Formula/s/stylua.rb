class Stylua < Formula
  desc "Opinionated Lua code formatter"
  homepage "https://github.com/JohnnyMorganz/StyLua"
  url "https://github.com/JohnnyMorganz/StyLua/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "e63130a0bc26d0825f99afcfb4d969516ab34dd1b397087bf564095766a16c2a"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e7cfefcc178b7f31de5fb95931d8461071ddf99fb7a10aa0a46e6657f2b30b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c9a823332f9a926f6997e2f9bf7c32d2b4dd85e4eb229ca2592af1121d8ba9f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "519236c7b6cbce2993396431fdbcdf8d9e240b0b78ead7e15840cd498d7bf302"
    sha256 cellar: :any_skip_relocation, sonoma:        "726d3da99c6fc59d5408126070163233945da5111b63cc7182177d9a8a2263fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd7c5eb674630ee8a3b88965a96fe33253d80b51a5beee6b493daca981443623"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97ceef0231c02a972d2d6594b67745d40698c28c5a1bf6f2f888484b46d8c4c3"
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

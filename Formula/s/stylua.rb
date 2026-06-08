class Stylua < Formula
  desc "Opinionated Lua code formatter"
  homepage "https://github.com/JohnnyMorganz/StyLua"
  url "https://github.com/JohnnyMorganz/StyLua/archive/refs/tags/v2.5.2.tar.gz"
  sha256 "26a220c7bf3a8f50d12b76c952fc4569a1162e2d002440faac3344a3634db4f2"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "abfa6ba1c8d10940ecbe87fc4aa1844cdc66fbb5dd082e11ada8a5094f064761"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c234e07172b905f7ee03e5f980cd1fb13f8e019812a91789a53ad122029f52c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c964397a87f55ad52c735b2af8625d8ad3f1bf1d7c0f94cb51ea5826bd5ae5cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "4249bd2b79a3babc81fab28d1f5625a40e6aeb85cc7515ebdf4b552047da43a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b0af7f4beda203887b50ee0ed24ee9b7f99a582846f47841b67887d42f6c80e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8feb3786e46fa56e32eb627e3989e31c6e15bfa2dd25916d88196704ee38768d"
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

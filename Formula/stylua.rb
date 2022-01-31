class Stylua < Formula
  desc "Opinionated Lua code formatter"
  homepage "https://github.com/JohnnyMorganz/StyLua"
  url "https://github.com/JohnnyMorganz/StyLua/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "96a43de18ec7804b69453e6c4c4595eb343d4df2d41bd58746b4b0c34058a95a"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5717fdd05c47904c7fa26bd84579d91fdbe89eebc21921f436482b06095469bd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9cead650320f2ecc3b4695ab9762b25da417087008e51d257a21718f76bc03e4"
    sha256 cellar: :any_skip_relocation, monterey:       "997ad1879a6a6875a576e31e15128354e8a6be0e89c2f6cc3dd473edd7f6fa93"
    sha256 cellar: :any_skip_relocation, big_sur:        "12fbcff0c10ad9af613fa3c46c05cea822103bc65448aba01a01c5e669a8216f"
    sha256 cellar: :any_skip_relocation, catalina:       "48fed2074fff65820e0dc6481fa12aa64ede957eedc2a14ab932c05e69c103ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37796db26b0f777cda4631b66a4c4d07f47637bc47dd0490d59ca642333a62cc"
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

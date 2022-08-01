class Stylua < Formula
  desc "Opinionated Lua code formatter"
  homepage "https://github.com/JohnnyMorganz/StyLua"
  url "https://github.com/JohnnyMorganz/StyLua/archive/refs/tags/v0.14.2.tar.gz"
  sha256 "606c37b84110739c375339aefeedc74a9906e59c4f559e112fc0948c13728a7b"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8aa739fda70dd6ffbbc7c18a555107a086f16a00f6287a3292c9162961d3261b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fb3f1ed91760169e09eb5e664a0f3f20a699c4bf0896cfd8b1e82af61d5df450"
    sha256 cellar: :any_skip_relocation, monterey:       "b9598c039655a6388ee159d00daa3ad3b192cc1df62b4c2ecaaf5be5632d156b"
    sha256 cellar: :any_skip_relocation, big_sur:        "f4f535c640c45e0984412d6c475dc4291017b2c061379a0bbe87d78fe0c01470"
    sha256 cellar: :any_skip_relocation, catalina:       "fa48e1e03e39325197f9494606c2aa2971ec0c77f807fffeaa67aa01dea40bf7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0eec7dd854a5cc9318f54116631eed90a7d6b290a880218a39f43f88bcf6bfe"
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

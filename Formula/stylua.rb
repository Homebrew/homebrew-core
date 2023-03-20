class Stylua < Formula
  desc "Opinionated Lua code formatter"
  homepage "https://github.com/JohnnyMorganz/StyLua"
  url "https://github.com/JohnnyMorganz/StyLua/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "ec659abac6dbe18b7ac0d53e830ab7a14805b389aa0ff97c06cc7fbf3f341292"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df0fd166bf9b7263a655fd652f7df4915ad9a7531330c1f36d8e58310f86a334"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "38d2886549dbce73612a22dacc8c34772a5fa23c089507cbca02dbdd29862f40"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "282f5896eb2db78fa94d7f4fed6fe1eb6cd49cb8522e9d605c855ffd15d4f156"
    sha256 cellar: :any_skip_relocation, ventura:        "767ef0db61b352fc8ca1fda50a89dad11a43dbf3eec266ab2cfb5b8603d85d5b"
    sha256 cellar: :any_skip_relocation, monterey:       "5d55a3b45147beeba666dfb1eed5426158eddbb4b5afe0fdfa7b1ca7db8cabb5"
    sha256 cellar: :any_skip_relocation, big_sur:        "eaa066bb9202bd2e86fbb21d725629afa9477c421defc00aa60fdb19edfcc3a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "018e41ddf595adfba08f066f6e90c163abd384f6c29c5d82255ec3c06b977ecf"
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

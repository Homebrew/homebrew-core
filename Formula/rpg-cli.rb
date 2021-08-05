class RpgCli < Formula
  desc "Your filesystem as a dungeon!"
  homepage "https://github.com/facundoolano/rpg-cli"
  url "https://github.com/facundoolano/rpg-cli/archive/refs/tags/0.6.0.tar.gz"
  sha256 "eef8ec026d0f49d00c05587984e4dd24e477efeb4b674be9a5cb992be876b163"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "71a7f4d9994d9a068ef2cbd8190ab253b1a68e19e1c02d99f7e92455e4f5967e"
    sha256 cellar: :any_skip_relocation, big_sur:       "090d65fedb311be5e087d41fcc8d098420632c3592c8a48902f2e0747edb4d54"
    sha256 cellar: :any_skip_relocation, catalina:      "644de7512fdef0e28a32b03590998100cb32f39adab9688dbfd8e701d781bdc1"
    sha256 cellar: :any_skip_relocation, mojave:        "8931b68e8b1358918e7866a5a16d7c68464e650271a4b61551c91285c2eb44bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc79beff2f1214edbf8db6c97237ce0d5a86277fe481d585a3087cac0b2e28f2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/rpg-cli").strip
    assert_match "hp", output
    assert_match "equip", output
    assert_match "item", output
  end
end

class Starship < Formula
  desc "Cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/refs/tags/v1.18.0.tar.gz"
  sha256 "e387ead17edeccb603b15dc2bd9b61c6541e795e0f4a9d9015015743228c2368"
  license "ISC"
  head "https://github.com/starship/starship.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "58efc19ef25c237ed5d6272fd4dbaa4124901384f80f16dacba99bad617dfab3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "51eb13f179f91c5c507c818c895191c078b81f89e870a5015a1d4ac092520efd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a224fae1f0ca4c773609bb788983248bce98741245a03fdc9cc13d409ac9ea37"
    sha256 cellar: :any_skip_relocation, sonoma:         "0aba709eb27b0b45a38650a4982d3fe7fd66538ce5c668762ae8977bdf6431bd"
    sha256 cellar: :any_skip_relocation, ventura:        "ef1ca68886814af8eec77a8063cff0158ead9074efba593ad8a4dc575dab5fdd"
    sha256 cellar: :any_skip_relocation, monterey:       "f37a8ae5e7ab4f6785eda4ddb71c89d1d99a2ea4f4b9b061b8b328cf0d258dad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1258810fd14a8b9896c09969f04f401a7d54d5d44398eb5ff8a95a2b3552fe06"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "dbus"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"starship", "completions")
  end

  test do
    ENV["STARSHIP_CONFIG"] = ""
    assert_equal "[1;32m❯[0m ", shell_output("#{bin}/starship module character")
  end
end

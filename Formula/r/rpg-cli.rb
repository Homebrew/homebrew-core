class RpgCli < Formula
  desc "Your filesystem as a dungeon!"
  homepage "https://github.com/facundoolano/rpg-cli"
  url "https://github.com/facundoolano/rpg-cli/archive/refs/tags/1.2.0.tar.gz"
  sha256 "f3993abe7b73666bc3707760dcc650aa9190cd3e7f06be846a0b6adcbbc46663"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "edd64ad86609935c99c399b86b814c9a7a610ab4cb5c4f18f11e5af5ff740d3b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a8df05e6cd29026836157d0d4e353c0bedc5f6e2277bce65c6fff92a05de4325"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed6c2539e1e7b9d1079bdd4f44657f0e9cbbf080b26b10914740e1c4e1c66c5d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b3aa7bb85909465f6294355b202e8fdea963e623597df22577379e5188a79fff"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b8763db1563256899273d21fb28c19886c4d0f65ec4d65cfe2ad3399d538c48"
    sha256 cellar: :any_skip_relocation, ventura:       "9b44a22701315fd658b98b3709c98ce4217076c1b4e37b717d4e687a15500d94"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c17280c6a4287274a9ea54c9986a47fc3ddb053bc21748ce0ca91d68a5c20d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "558c7cd2a9865a8f476b81da9c4f75dddad70a0f07ea4aab349ba9260ae822c6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output(bin/"rpg-cli").strip
    assert_match "hp", output
    assert_match "equip", output
    assert_match "item", output
  end
end

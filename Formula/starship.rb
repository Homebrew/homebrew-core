class Starship < Formula
  desc "Cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v1.11.0.tar.gz"
  sha256 "7b408ef8a2ab47d7a7d0e120889bf12c8f2a965796f8a027d8b2176287fdec6b"
  license "ISC"
  head "https://github.com/starship/starship.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e82c237024245b338dbf0f3c928a05331d660e1f7e34882bc02796c13b90dd54"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f74ee071e7bfe07eafa8669e5535f7f6779366ad80d03fe7609ebdd8338b4fc4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1ca97b358ec38bc8ee0e7f969d737358452db909c819f9aeb9b24cb4c1acd904"
    sha256 cellar: :any_skip_relocation, ventura:        "b2d3f5cf93491b77ee2f0a0646b25e4b871c25659ac414974f75eab2e46b4558"
    sha256 cellar: :any_skip_relocation, monterey:       "0307c6c463623dc15883119240259c1938daced16c133329e9163c8544cf63d3"
    sha256 cellar: :any_skip_relocation, big_sur:        "dbdebf730799d739164472dc738b11e38092600cb5c0ab5304ad73a86b8e3a3d"
    sha256 cellar: :any_skip_relocation, catalina:       "1c30ef3224d2baed5bbfba4bad8ec7a6b329abcb0354d74ddd4c4d78a40d9a64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4507d8939df5833d693b4b6cbbc14f721a973a56f99281723e276dbdc75deeec"
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

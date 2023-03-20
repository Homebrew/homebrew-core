class Starship < Formula
  desc "Cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v1.13.1.tar.gz"
  sha256 "6cce984c7fb0067b9dc457274139f277e2ff56488811c96a7ae68102184656f9"
  license "ISC"
  head "https://github.com/starship/starship.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d12ac9dcb05ca2ea86b943be41eaa32c2850ae429b6fc576c280f1e78514613"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5eaafb06f2d76282359dd33a35e0df8a6a20c0471cf262244b01524d1f2597a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f6117338c98223bd121a6ebae87f4e294bfb300f8f7d9f845d1f78532cf5ceb2"
    sha256 cellar: :any_skip_relocation, ventura:        "1e50ab8e5c2dbcb4176c38c006ba586c9f9c70f2ce1eb03f74126cd22d3bd77b"
    sha256 cellar: :any_skip_relocation, monterey:       "7ca4f9822b6c8bd33880b2703234fe3e5d5bac3ad23f1365178e587155260d3f"
    sha256 cellar: :any_skip_relocation, big_sur:        "fd180eb92b4822ed728c1810cbaf1d4ed73729961ca38911f8bde86082d9e22a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7404de9f003218aa5bc90d4decf01ddd690110c2bf9af321f924e9c2de2d2c9b"
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

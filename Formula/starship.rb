class Starship < Formula
  desc "Cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v1.15.0.tar.gz"
  sha256 "e525476cf93d3a06332abf9e02415d4789fac6f28e4b7d98db7d83da08231828"
  license "ISC"
  head "https://github.com/starship/starship.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f9c6757bb1e1e271e7300d2b63e910ab433e7972eb312880eda483b693d7ba7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1cf8674b4a8d34744fcd8298c020ed8375e5b47f9ef0d5d3c92faa3fc16f9032"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8716902b73f2a387448079d9c8f05057b4a52f05e7fdded5e608ff90e588d9f6"
    sha256 cellar: :any_skip_relocation, ventura:        "e941a6128d20a7278b3c471f8e56e1deb0c6ca33c222bcce98decc8de08f2c09"
    sha256 cellar: :any_skip_relocation, monterey:       "d56a0f4d9f49f814df218bb36b385fc56ebef5bce9ba6bf164c0b35cf5e0c962"
    sha256 cellar: :any_skip_relocation, big_sur:        "2376b47c7fd6486c11d88c6b62f80d53c26bab3839247e68b6f36b9ebbc09719"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9fdecc12a36bb24e7c5fe36b2b5512985d2f82dbf6c37cfdab76df82da42e244"
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

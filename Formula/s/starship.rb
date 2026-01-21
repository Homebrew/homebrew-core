class Starship < Formula
  desc "Cross-shell prompt for astronauts"
  homepage "https://starship.rs/"
  url "https://github.com/starship/starship/archive/refs/tags/v1.24.2.tar.gz"
  sha256 "b7ab0ef364f527395b46d2fb7f59f9592766b999844325e35f62c8fa4d528795"
  license "ISC"
  head "https://github.com/starship/starship.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f27075bb7a643a641245b9f559cf60d2310727d7166dcbba498e629dee23b00f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "254e15def4475b164ab4ae5817b2230bfe72b041671164f92ee1738c88c53ea4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50e84be143b72b825f899c47f5aa96c02f096ad64a5c2c589da1a8f55e7761c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "a99ad82097bba0d6f0fc3254ab1fd619cd432cd537cd820250b719e6e0271ad1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8b75297dddbdd9ee53ad4b714b1f49ca9d3bb52fbfa9c6c345afb03221170aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9b8973bf593afe79f66dc0eba557dcf93661bd32882fb477acba612eb2377c8"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
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

class Starship < Formula
  desc "Cross-shell prompt for astronauts"
  homepage "https://starship.rs/"
  url "https://github.com/starship/starship/archive/refs/tags/v1.25.1.tar.gz"
  sha256 "521306b14066ee7e332d998ef5b5b6455fdc6085c52e86b6316a7cdc37bae1d8"
  license "ISC"
  head "https://github.com/starship/starship.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "521ea566a901ebdf2f7b3069cb09202f29b3409297ad513117374cdabb7118df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "463abbce6bf503bd410da4e1bb16274f28250c51cb82b26cc9641b152961af11"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08e4597ba807df7c97147e4d94346e48f452497a40b131f44e043e49ecf1ded8"
    sha256 cellar: :any_skip_relocation, sonoma:        "57ab42e838728748dd11f04f03406c45f9668f0fc6040b5f899d8b51b1f7978d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c47bf8549df3c01a631293285d355284df765c669471463f94cab6422e5f99d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7ae20ebb493284e20b494d2dbc6fe398946d4fce2022d246cd14b517f8afac6"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "dbus"
    depends_on "zlib-ng-compat"
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

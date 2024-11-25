class Starship < Formula
  desc "Cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/refs/tags/v1.21.1.tar.gz"
  sha256 "f543dfa3229441ca2a55b8a625ce4bad5756a896378b019f4d0f0e00cf34dcc8"
  license "ISC"
  head "https://github.com/starship/starship.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2bcf17d726950f2a9658a5efba92923f2fa898d972a494818e48cc9e6c68d9f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "856287a509adf492e5bc07561a8a88f5932cbfac917df5a22ce5fb8ef6b860ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a20e48b1522f4ed5dd0129b66d04434f61c224ce3e529330437e8f986b0fffba"
    sha256 cellar: :any_skip_relocation, sonoma:        "6182681db64704a0883119d2bd69469cb82e236e13b0e82978d2e5f5024eae01"
    sha256 cellar: :any_skip_relocation, ventura:       "0c129e5d081e44c0bd65f0a27713180ce6e3eb24ba1d772fdbd25a32b37454a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5e13f280511bf5df92ebca6b49b2391352d4c775060fe9dc24839a57392e677"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkgconf" => :build
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

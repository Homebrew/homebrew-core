class Starship < Formula
  desc "Cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/refs/tags/v1.20.1.tar.gz"
  sha256 "851d84be69f9171f10890e3b58b8c5ec6057dd873dc83bfe0bdf965f9844b5dc"
  license "ISC"
  head "https://github.com/starship/starship.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "26bf48ee3cd1377bf1975b130214914f5df26fd3133a067465008e3a773b7704"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0c4a9a5065b898767b818d6efd9967a8721584b856d2ae50291d93378dd6308d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e45c4772e04bda7e40ea8c87c67665ca60c1bd50ee62a5808ac40422f0506eb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c8a3541a380c006638c61de8613a66232f307f7b933e8a8c376bd2986ec74108"
    sha256 cellar: :any_skip_relocation, sonoma:         "4d29c18c5c58c41bce81e84519650310694db6f26172191bb880253176aecb6a"
    sha256 cellar: :any_skip_relocation, ventura:        "4da07ebf4ce68ad9c995981099605962721e4b68aa3c2ee75964bea9654c5516"
    sha256 cellar: :any_skip_relocation, monterey:       "dd431900a3a652d4588ea1c915ee6765d7586c7d68aea8cb17218e8a6e336c0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47effdd4cebfc40f3d4518bc941eadda39a423af2980b625f4bde2bbcadee718"
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

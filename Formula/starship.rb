class Starship < Formula
  desc "Cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v1.13.0.tar.gz"
  sha256 "824ca9fb4c7a49dba2c9b4060b1d666d34a33b4ed7aecdfc1512c66344f166a3"
  license "ISC"
  head "https://github.com/starship/starship.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "01f950a875e7903eafde1bc29121e8f0d30e33a73f8ef514a21c63907c3a8b9c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ddafeedf0a4a3677a4abc46dd237879fabd1b449b4254418f1e8ea5fd19c180"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1c57117968bda80a63bf9edf6b585418aae20fc45a23b23e0a6eebc958eff66e"
    sha256 cellar: :any_skip_relocation, ventura:        "4ebc3aff8e3bf7edb0516ab404e320ecd26282671b79e8f4259e49c545b21769"
    sha256 cellar: :any_skip_relocation, monterey:       "ed2c1d864d2097f92c5a329e2795839588437d78418f326c225d3554ab8aaa2c"
    sha256 cellar: :any_skip_relocation, big_sur:        "b57426a31e55cfde0bbe56211b9509974513d5283b51d8048448c883d136b10a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8bdd32cc58abd1cc4e3f532e33ce64231fe2d9611f344d49326851c07d0a932"
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

class Starship < Formula
  desc "Cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v1.9.1.tar.gz"
  sha256 "2b54bee07bf67504a1bb170d37dc8d6accab4594d35731bbdf0e8a631c8d1585"
  license "ISC"
  head "https://github.com/starship/starship.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4dd493736c8dbd8eb18f9d6ab24304c9b60b46c79756320131c98ace756981b1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d6d3d27a036936782bb6108e9e002ee95e914edfec008ed0bef0890732e0c2ba"
    sha256 cellar: :any_skip_relocation, monterey:       "86de7a29a589a35dcea0b6c32b4b17e72061fa4fc4e594ada8cd410a94f9779f"
    sha256 cellar: :any_skip_relocation, big_sur:        "56d37a05a06cc5ac5927c5c3f60b45b73fade4cf70b4852fe8569160a2eba11b"
    sha256 cellar: :any_skip_relocation, catalina:       "8c10d115e3c349e75f0993db387af4e8bca1750491c4d56b997fa9d492392727"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f69317244e491266b67286a15f4169815fa5731bc8d921555948b57bdb55f5f4"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "dbus"
  end

  def install
    system "cargo", "install", *std_cargo_args

    bash_output = Utils.safe_popen_read("#{bin}/starship", "completions", "bash")
    (bash_completion/"starship").write bash_output

    zsh_output = Utils.safe_popen_read("#{bin}/starship", "completions", "zsh")
    (zsh_completion/"_starship").write zsh_output

    fish_output = Utils.safe_popen_read("#{bin}/starship", "completions", "fish")
    (fish_completion/"starship.fish").write fish_output
  end

  test do
    ENV["STARSHIP_CONFIG"] = ""
    assert_equal "[1;32m❯[0m ", shell_output("#{bin}/starship module character")
  end
end

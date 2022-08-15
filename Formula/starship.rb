class Starship < Formula
  desc "Cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v1.10.1.tar.gz"
  sha256 "0dcf3a087748c241207a8c86a8c7b6e4d5558916d22deb4348942797d58c3ed9"
  license "ISC"
  head "https://github.com/starship/starship.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5924af807473ce634edb242617fed603469be06e8e3284a35d1c47b892fd3b47"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8eb362f7d89a4ca8b39772846be20f32381507ecd77d480b0d8705a7af43952c"
    sha256 cellar: :any_skip_relocation, monterey:       "6fa210a4b0f79f6ba59f2ae5b15fbb8225ba1117b9edca368f23c94cc5579d5f"
    sha256 cellar: :any_skip_relocation, big_sur:        "7504894d26af6705d5a1700fe95adb0fb53996249421cb9eb2efc41e15b9acdd"
    sha256 cellar: :any_skip_relocation, catalina:       "b7119a2b4abe5d266778586211b83102568ebf4c7424170171d8abad3afb5da3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9161c84bfd2cac96467b92dab15948942d282952d5e90de1fdb587690c15164c"
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

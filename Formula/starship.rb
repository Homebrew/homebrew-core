class Starship < Formula
  desc "Cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v1.6.3.tar.gz"
  sha256 "a6219189eb1e9182eb092213ce4cdd5fba84ae148cb9c4188610a907231a77c7"
  license "ISC"
  head "https://github.com/starship/starship.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "601eea0b43d02cc3915d8ad05332165f8221413e285dcae6568cf9e92c851fc2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3c916c22b30565c19a99a55651427c4e6a6fc9280cee84534f91f3fc92a93f58"
    sha256 cellar: :any_skip_relocation, monterey:       "f9faf7e11e0c084af65b2b112452b4075055d895dbf8f9b0511a050fc4c46f61"
    sha256 cellar: :any_skip_relocation, big_sur:        "38814af866d5a380cb462ee4588c0edbd2df552ea465a31e19d6ede4ee9212ae"
    sha256 cellar: :any_skip_relocation, catalina:       "013399983fa97575466e9a3e325f68fa043e0fd97c4434e4ab2058b9726a78bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac0c45d0af3dd6aa7314587e7da4a06efa44bd47214e29b71c898c12ce12e685"
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

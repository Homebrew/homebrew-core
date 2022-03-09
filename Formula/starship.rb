class Starship < Formula
  desc "Cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v1.4.0.tar.gz"
  sha256 "8340b8b7a4b75c17f3f72c6a4a81a8470c003719594f6884b151490a9433461b"
  license "ISC"
  head "https://github.com/starship/starship.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e7d52e926fdce2359549cd18a4b73958f7af6519192872884647da73a9206a3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f1faf77205e00e029a79f0f4b91fd9ec20692e6369115f45612d1cb55eff1528"
    sha256 cellar: :any_skip_relocation, monterey:       "e963afddc1937606c618baef8cdfa87c805202f838ee7c5580e80a69305e3836"
    sha256 cellar: :any_skip_relocation, big_sur:        "63f081b4ec673db4525a80b8ce483abf5882aaa271b92952ee6a4b6ee23cf9be"
    sha256 cellar: :any_skip_relocation, catalina:       "fe5841b1f33e298a03ebfd99e3ee021ddfa1bd66d6bf0ec2278c6992784ac8c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "001bddfeab4415c1c36b81926d983c38581d855e3bccd8a9bce0707101bdf6e2"
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

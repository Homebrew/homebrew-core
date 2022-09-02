class Zoxide < Formula
  desc "Shell extension to navigate your filesystem faster"
  homepage "https://github.com/ajeetdsouza/zoxide"
  url "https://github.com/ajeetdsouza/zoxide/archive/v0.8.3.tar.gz"
  sha256 "eb1839a4ab0ce7680c5a97dc753d006d5604b71c41a77047e981a439ac3b9de6"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a1d5e8bd9e26a302e9680a8adce9f5b4984ec4963f1d3918ab49413acbcdd56"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ed3e4c8bc8871c92c0e0e970095fceb26999229f3fd488d298a05544fb7b3149"
    sha256 cellar: :any_skip_relocation, monterey:       "f60a6653256401bc29b0d8ae1f127d86428f11f55f177358d64e3665ab06f632"
    sha256 cellar: :any_skip_relocation, big_sur:        "932a866cbab3b33a14919c1abea05e23ba58261e4c79b1800f1e220bc18356cc"
    sha256 cellar: :any_skip_relocation, catalina:       "01cfa4072bf6d28a803b86abc5f2e5b003655652a691d805f42a45ca39022a40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f7908ae31c7e04e54caa9e176911e20a8368410ca0e663d1e0be4e96345e83d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    bash_completion.install "contrib/completions/zoxide.bash" => "zoxide"
    zsh_completion.install "contrib/completions/_zoxide"
    fish_completion.install "contrib/completions/zoxide.fish"
    share.install "man"
  end

  test do
    assert_equal "", shell_output("#{bin}/zoxide add /").strip
    assert_equal "/", shell_output("#{bin}/zoxide query").strip
  end
end

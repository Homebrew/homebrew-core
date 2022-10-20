class Zoxide < Formula
  desc "Shell extension to navigate your filesystem faster"
  homepage "https://github.com/ajeetdsouza/zoxide"
  url "https://github.com/ajeetdsouza/zoxide/archive/v0.8.3.tar.gz"
  sha256 "eb1839a4ab0ce7680c5a97dc753d006d5604b71c41a77047e981a439ac3b9de6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c4b765fc1f5de400790541744e2405b7419706edc380361dd55db988ebbe2a8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0bc18f6f0ccb882273a2fc13887dcc19acdb8534ea5a4b678ac7bb0d7dee25c9"
    sha256 cellar: :any_skip_relocation, monterey:       "46ecf574f1aae6775497692e72dc23106627ff8924d055a85d1b5573c33d2a8a"
    sha256 cellar: :any_skip_relocation, big_sur:        "9ac7190f36c3d29f98385b621d6a72274a1dba78cf7e3dd613bc2c2cec4a1c27"
    sha256 cellar: :any_skip_relocation, catalina:       "4f0b6d0a0266fde65462dd30c676e9af066a0cf3bcc061cb70f6a80a379d402c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "518af8008a52ad206b92820ce1dca7eb713bdf63f4ba6509eca3441ef9b8b810"
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

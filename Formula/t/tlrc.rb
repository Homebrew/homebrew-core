class Tlrc < Formula
  desc "Official tldr client written in Rust"
  homepage "https://tldr.sh/tlrc/"
  url "https://github.com/tldr-pages/tlrc/archive/refs/tags/v1.11.1.tar.gz"
  sha256 "02262b432dd188772577fd3a37f8a236d46d924291ec1d013e419c77f7256f4a"
  license "MIT"
  head "https://github.com/tldr-pages/tlrc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80196e92b44c096505b91bf92bec2e8977fc0af0209b2fa1a3f7bb8a5418bbf4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7cc33f44d74c59ce048151d8a24dad087f194f1d3947125880d4d2f605291ffa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0ce3cb5e0a62793a22eea427210e9c2bd3d9d11666f53e78a854bd275737c137"
    sha256 cellar: :any_skip_relocation, sonoma:        "78ebe413ffdcc20b39d57be1ecdacc4f724985479921d68bdf63b828497b6718"
    sha256 cellar: :any_skip_relocation, ventura:       "66f47cc38095e70784b629ca23a09788b51769a0aecad1bbf15031727146d3ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "40801ebf82cda26ff5426892650957b3ccce7af70e4492872f335f23c309a4d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed920bb75de0ad493b221105e3eaad4528d6f17ab2d75c748fb48ffb46859fa6"
  end

  depends_on "rust" => :build

  conflicts_with "tealdeer", because: "both install `tldr` binaries"
  conflicts_with "tldr", because: "both install `tldr` binaries"

  def install
    system "cargo", "install", *std_cargo_args

    man1.install "tldr.1"

    bash_completion.install "completions/tldr.bash" => "tldr"
    zsh_completion.install "completions/_tldr"
    fish_completion.install "completions/tldr.fish"
  end

  test do
    assert_match "brew", shell_output("#{bin}/tldr brew")
  end
end

class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/lotabout/skim"
  url "https://github.com/lotabout/skim/archive/refs/tags/v0.10.4.tar.gz"
  sha256 "eb5609842ad7c19b1267e77682ee5ae11aa8e84e46c27d9d198cc22d00c5e924"
  license "MIT"
  head "https://github.com/lotabout/skim.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e8607c7f9e3c72059b5168aded78582bfe459e754381f669cce9a6169523832f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0aa120c7df0fb4a61903c952d5a64dad4030a0b1a48df8c2d0bac01dac458ec8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e28dbbdb5930443d04b934d8966af2dec58f037f859432f7a412c52568990e1d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a96933375963dac24744a541d7835a9694bf9050481e8d302b9f22187a0e8184"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e7b9c3bc71263bd5f16a6cdf08cb36e1076ea698f5b26fcac5fa8fe1c82032c1"
    sha256 cellar: :any_skip_relocation, sonoma:         "e6e9e40fdafaf8d5807947b960698535edf426923fbcef6ebc5ff70dc114aa89"
    sha256 cellar: :any_skip_relocation, ventura:        "afaa23049ae7c7268e5bc86bdba95abe0d99dfe83057c4614ce95ae7ac580830"
    sha256 cellar: :any_skip_relocation, monterey:       "de7b821fe89afa96598770fdd98d7b55a78b57be6867284f6e4aa41db9469331"
    sha256 cellar: :any_skip_relocation, big_sur:        "ab8e698b22382f4faed083f426fb8aa1fa0e0393c7e43169deba03021fa502ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9dee90b1f10ffc8ab60ed7549c0c5fb16afda00b94de1a34eee59ffd21205412"
  end

  depends_on "rust" => :build

  def install
    (buildpath/"src/github.com/lotabout").mkpath
    ln_s buildpath, buildpath/"src/github.com/lotabout/skim"
    system "cargo", "install", *std_cargo_args

    pkgshare.install "install"
    bash_completion.install "shell/key-bindings.bash"
    bash_completion.install "shell/completion.bash"
    fish_completion.install "shell/key-bindings.fish" => "skim.fish"
    zsh_completion.install "shell/key-bindings.zsh"
    zsh_completion.install "shell/completion.zsh"
    man1.install "man/man1/sk.1", "man/man1/sk-tmux.1"
    bin.install "bin/sk-tmux"
  end

  test do
    assert_match(/.*world/, pipe_output("#{bin}/sk -f wld", "hello\nworld"))
  end
end

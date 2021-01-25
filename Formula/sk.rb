class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/lotabout/skim"
  url "https://github.com/lotabout/skim/archive/v0.9.3.tar.gz"
  sha256 "c4eea49ae3b22896d9d671e4ffa95614e4bed4fa996882b94738490bce863926"
  license "MIT"
  head "https://github.com/lotabout/skim.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0d760d248a659112d772854614764286b3bf09616f344658481e09d5642246fa" => :big_sur
    sha256 "8a9e3271b0f8569f4a4e37e3c417b9aec43d37d9a652f5ba41660b6fc0b387a0" => :arm64_big_sur
    sha256 "07b4b9382fa9a43d57609d18481fd63b0b4561b09d625762e68c0fcfefc0120a" => :catalina
    sha256 "a299f9fd5ed97d733838ede34a7602ac9682fe3957de49faf660aa2aa086a15a" => :mojave
    sha256 "d80ddfbbca4c831a61d987edc3554cbb32d6d93ff65054b99cb67eb796854349" => :high_sierra
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
    assert_match /.*world/, pipe_output("#{bin}/sk -f wld", "hello\nworld")
  end
end

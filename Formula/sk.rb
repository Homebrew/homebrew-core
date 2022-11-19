class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/lotabout/skim"
  url "https://github.com/lotabout/skim/archive/v0.10.2.tar.gz"
  sha256 "a46b670848b9b083cd45cd1db36387efc73f856972531d9f156988e83a0c3c07"
  license "MIT"
  head "https://github.com/lotabout/skim.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd30111a8b87432ba0c3fe10050acf7641293a7f766b4359b563f7e1a9dfaf9b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0e0662c016c6dee5e56147a400a2a6c0b4793077e4185b68f800f5861632097"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "31165c924fa86cfe04ee1a5d4676552cbc1fe1a03f55e90e202bd37df74d58d7"
    sha256 cellar: :any_skip_relocation, ventura:        "5759763d269992351a45f643f5d3cac10e959268caccc674e32ab0bf0287edb0"
    sha256 cellar: :any_skip_relocation, monterey:       "9f71e768a60eb114ae7ff01f4f92eda3b01c9da58ee601e6196239a7b619cd26"
    sha256 cellar: :any_skip_relocation, big_sur:        "f4b8109d55e3e1dc7e453366620cb7525de0cd5a914352ba343fc91f5bfb33f8"
    sha256 cellar: :any_skip_relocation, catalina:       "ee3ef10bbe963896117c5aed403999eb660458e7cb14e00b618833077fe5f91b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e34712cdc78fd7058c5d6121fd92df8b3fecd9e3679e6c205fc3b4ec5c3a546e"
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

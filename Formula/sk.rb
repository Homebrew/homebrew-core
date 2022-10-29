class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/lotabout/skim"
  url "https://github.com/lotabout/skim/archive/v0.10.1.tar.gz"
  sha256 "7ff0626a185c06eca2e71858a1d656aed08b3932db8a6f6f59651d3e7a5e515f"
  license "MIT"
  head "https://github.com/lotabout/skim.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c651b86b1587de405d3e4412f045229245873e5136a18f6e3f5a498053dec96"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "79aba553a2d2f412315dc6342dc0db3dc684b9cadf06c69f23fb98373bd1078a"
    sha256 cellar: :any_skip_relocation, monterey:       "5a0b454933322c8969b92b9f30442ac6ff9e1841b992f49f4152a74fe544e8a3"
    sha256 cellar: :any_skip_relocation, big_sur:        "9502b83160e0fed5ad79374ea5d702609c09eecf08d2095706a62a74ebe0acd2"
    sha256 cellar: :any_skip_relocation, catalina:       "f1a8ef3f930a40660fc965c5d94926368b8a5ae30d29bdbcaff885d17051211a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e3ef4b88c79c5d686ccf86d9383048dc0840189f0cbc865abd3147ce5969f07"
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

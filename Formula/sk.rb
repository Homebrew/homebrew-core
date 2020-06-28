class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/lotabout/skim"
  url "https://github.com/lotabout/skim/archive/v0.8.2.tar.gz"
  sha256 "04af8e9facd8a9f10e9d18f02b78e6d80e987cd58937df960c9b48ae5f42b761"
  head "https://github.com/lotabout/skim.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "49d4aa812c18526cd80fd3d98bd8069c5287b82c9ecf8381ee0d37f02c4a6941" => :catalina
    sha256 "574387cd28d9108a276c93fb9bc29096c0e38a6fa6edff8df21496f2b25f2e99" => :mojave
    sha256 "a104ecf57abc9a3b2f99369a5c96a5cd05ebb82a6a3425625b2fad6d9d46700a" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    (buildpath/"src/github.com/lotabout").mkpath
    ln_s buildpath, buildpath/"src/github.com/lotabout/skim"
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."

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

class Zola < Formula
  desc "Fast static site generator in a single binary with everything built-in"
  homepage "https://www.getzola.org/"
  url "https://github.com/getzola/zola/archive/v0.10.0.tar.gz"
  sha256 "af8160f1536c9b69153dc041a2e23f359b6acb2a9a2235333e887397d8a6634d"

  bottle do
    cellar :any_skip_relocation
    sha256 "0a5ca06ab0dad7b87501ad2edd70bab6097b412ac9093e2b957c036c4006aee9" => :catalina
    sha256 "869acb1f592805aa2d7ad39df92f49cd77dd5f64e42b70ea3e91761001081765" => :mojave
    sha256 "4555f98aa2f8fc15a5813c2cdb54fc46fd4b779a64f90f80352e469ea9d92e26" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."

    bash_completion.install "completions/zola.bash"
    zsh_completion.install "completions/_zola"
    fish_completion.install "completions/zola.fish"
  end

  test do
    system "yes '' | #{bin}/zola init mysite"
    (testpath/"mysite/content/blog/index.md").write <<~EOS
      +++
      +++

      Hi I'm Homebrew.
    EOS
    (testpath/"mysite/templates/page.html").write <<~EOS
      {{ page.content | safe }}
    EOS

    cd testpath/"mysite" do
      system bin/"zola", "build"
    end

    assert_equal "<p>Hi I'm Homebrew.</p>",
      (testpath/"mysite/public/blog/index.html").read.strip
  end
end

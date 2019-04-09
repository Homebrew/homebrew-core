class Zola < Formula
  desc "Fast static site generator in a single binary with everything built-in"
  homepage "https://www.getzola.org/"
  url "https://github.com/getzola/zola/archive/v0.6.0.tar.gz"
  sha256 "647f31300f4e468374dfb325b59a08cb31c4ed855b2e5b677131464ae3ee9925"

  bottle do
    cellar :any_skip_relocation
    sha256 "5031b4e225b5d7cdf6b2ccb774b38bfaffb65c6e7e223e34d73f4ca0df341824" => :mojave
    sha256 "90351fdbd97ccc147124454b57fe3f1e8107a5ef76421f3c1011309659dc39fa" => :high_sierra
    sha256 "3eeb73a933b7de894f222c4e5c8001f8507c437a95dbc592ddb29b7c7cfaf5a4" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."

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

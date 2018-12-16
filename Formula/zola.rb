class Zola < Formula
  desc "Fast static site generator in a single binary with everything built-in"
  homepage "https://www.getzola.org/"
  url "https://github.com/getzola/zola/archive/v0.5.1.tar.gz"
  sha256 "d4fa5e70a8da2d2b544147508e8d44a081f19c7d6c002c32ee9661c7873d3c7c"

  bottle do
    sha256 "40725be4950469abd15b986fbc77b20306771ab2e011e578a6d55b7d56190bd0" => :mojave
    sha256 "545e31eadf477836206d1d69b7d024cfe9e3f3fd3a74d0653549d486559dd708" => :high_sierra
    sha256 "812ace288dd7dfdbf637eebdd0a1256fa5e9e9dba1233862f80935f14fda7d53" => :sierra
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

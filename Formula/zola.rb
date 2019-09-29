class Zola < Formula
  desc "Fast static site generator in a single binary with everything built-in"
  homepage "https://www.getzola.org/"
  url "https://github.com/getzola/zola/archive/v0.9.0.tar.gz"
  sha256 "a5b7658c9c56bd53613cd40254536ccdd6937444b935458c45416b8fb78bbcad"

  bottle do
    cellar :any_skip_relocation
    sha256 "d3a24de59191ce4b88524939a4c9b6010f2421d4c9e4fa4d6872adb6ec47d29f" => :mojave
    sha256 "e3f5eea15eac1b2850a3841afdd45419a5befe99684bcaad36c90abbd6d0a3e7" => :high_sierra
    sha256 "8b1034cc9fa42dca6e4c892f283a092150097562a949254e7247c0ff98a0bf1e" => :sierra
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

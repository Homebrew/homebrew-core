class Zola < Formula
  desc "Fast static site generator in a single binary with everything built-in"
  homepage "https://www.getzola.org/"
  url "https://github.com/getzola/zola/archive/v0.5.1.tar.gz"
  sha256 "d4fa5e70a8da2d2b544147508e8d44a081f19c7d6c002c32ee9661c7873d3c7c"

  bottle do
    cellar :any_skip_relocation
    sha256 "2caa9813654f96fa12a85ef94723fb917480e9492a9ff113401591c5b9496fbf" => :mojave
    sha256 "e8e72ad23f0e0be1d2e6834681451e244147b36bb5f98daf80365e6ecb5c7be2" => :high_sierra
    sha256 "c46e18dc9827db9339eaf74f49d140d6ec165761ff4158a1579dbe943e32fbad" => :sierra
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

class Zola < Formula
  desc "Fast static site generator in a single binary with everything built-in"
  homepage "https://www.getzola.org/"
  url "https://github.com/getzola/zola/archive/v0.10.0.tar.gz"
  sha256 "af8160f1536c9b69153dc041a2e23f359b6acb2a9a2235333e887397d8a6634d"

  bottle do
    cellar :any_skip_relocation
    sha256 "2dfac53b9f826f22f9ffae18c8799b70ee60c82f05e4b8ed68cd8027a59dbc74" => :catalina
    sha256 "d4410cc94d0f7d2538118a72c81612db8894dded17b8919a8613042eb1154884" => :mojave
    sha256 "598fc17bbf51800f18671664acee37ecff19ab25f7ea89dd46366ba200f232e1" => :high_sierra
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

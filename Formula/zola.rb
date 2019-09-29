class Zola < Formula
  desc "Fast static site generator in a single binary with everything built-in"
  homepage "https://www.getzola.org/"
  url "https://github.com/getzola/zola/archive/v0.9.0.tar.gz"
  sha256 "a5b7658c9c56bd53613cd40254536ccdd6937444b935458c45416b8fb78bbcad"

  bottle do
    cellar :any_skip_relocation
    sha256 "6a41e2c7368f17f8d5114c7de5ede0d90b9f00c6960ab1e013661c47d949ee43" => :catalina
    sha256 "f4d5a27e87c7dee4f1043952fd760d3659a6357e70089f13423bdf2f49abd8d7" => :mojave
    sha256 "8f0f469086d4e20fa116c9ebdafec7089a07fff02b43fe911785da5fe53fdd68" => :high_sierra
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

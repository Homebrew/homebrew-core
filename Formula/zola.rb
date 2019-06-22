class Zola < Formula
  desc "Fast static site generator in a single binary with everything built-in"
  homepage "https://www.getzola.org/"
  url "https://github.com/getzola/zola/archive/v0.8.0.tar.gz"
  sha256 "c16909fc20ad3e2f922beb270b2350928669149ba2e958de72558f96620a9624"

  bottle do
    cellar :any_skip_relocation
    sha256 "449421b70b760ee6e5751522886afcdd0bdb8dc547835c051fccfdd67c39070a" => :mojave
    sha256 "b6b45e72dd6379adc3f745693171baa659d1e5b0799eebc0d918ce58d376e5cb" => :high_sierra
    sha256 "57dbc00aa4b53f65362803f8bca98cd9e6059aa3f9ba8477fc26810d05a806f9" => :sierra
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

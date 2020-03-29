class Zola < Formula
  desc "Fast static site generator in a single binary with everything built-in"
  homepage "https://www.getzola.org/"
  url "https://github.com/getzola/zola/archive/v0.10.1.tar.gz"
  sha256 "cf5992e935d2f236985b57f357bb6e6738e83b13b0ae50278da66382a0af106c"

  bottle do
    cellar :any_skip_relocation
    sha256 "1520621fa148090174e4b3732c4f86d595bd2e6804bc8943774e614d1408ac7d" => :catalina
    sha256 "0f4e61f9efce1567f82c5ca6c1d3b04ccdadaca96a5b24d148de214d79fd4552" => :mojave
    sha256 "6fcabfceefe7924916e35865ac0bbd0e643b9ea1582f6563273f942be9e67575" => :high_sierra
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

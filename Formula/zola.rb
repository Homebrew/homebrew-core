class Zola < Formula
  desc "Fast static site generator in a single binary with everything built-in"
  homepage "https://www.getzola.org/"
  url "https://github.com/getzola/zola/archive/v0.12.0.tar.gz"
  sha256 "d76b380189ddf9fa7ac3243aac8f47f38fb754b4c39f424a00d961c68f9dcd59"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "099ec6c5af34a200dbfc30f9f9fc1d085bda28326edc06738c29db3272af3e71" => :catalina
    sha256 "7ec8be7e3bbafd3fb41dae7ecee7f613cfe0c4b9120cddc9b9720603e74c282a" => :mojave
    sha256 "6a5820422c3ac9776b45f6c7f210315c8ae87d294fdea3db093f3e89f11358f2" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@1.1"
  end

  def install
    system "cargo", "install", *std_cargo_args

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

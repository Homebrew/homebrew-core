class Zola < Formula
  desc "Fast static site generator in a single binary with everything built-in"
  homepage "https://www.getzola.org/"
  url "https://github.com/getzola/zola/archive/v0.12.2.tar.gz"
  sha256 "1c0cb37e9a3d9f7ff41012996eb068fb5453c9727f107ac817429cbdae4dae84"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "5e4734cc94cedc96a02a930c6dd802caaa5fd841c2e0813013541349ea31668c" => :catalina
    sha256 "b30e77c8a3372f1578cd0cbbfc64ffa5e21524a8881d46e449ee8fd97a173dda" => :mojave
    sha256 "1d1b9e13e4804ddb0631808a406954f672db396c4e0b3d429f1602dfe5591d12" => :high_sierra
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

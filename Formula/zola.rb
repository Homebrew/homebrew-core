class Zola < Formula
  desc "Fast static site generator in a single binary with everything built-in"
  homepage "https://www.getzola.org/"
  url "https://github.com/getzola/zola/archive/v0.15.2.tar.gz"
  sha256 "9f6b1527e728cef3536e42a18fbc06647b388fb34fc07cc7aca82e44f4fa3447"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7795cef21bcedd6719fc727da19594d860c97f35882e927819edba4d6eb12485"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e944388783159ce6fed070193c7b890fa68f97b22999c37475a64f3c95dac088"
    sha256 cellar: :any_skip_relocation, monterey:       "757bd747e13fa4087d57a8523e595e6f3f9a6611a0f5cfaed3520d7a20c37456"
    sha256 cellar: :any_skip_relocation, big_sur:        "57724d2b62f884dbb18027470d17f2cc2ae130b0a08484f3cae43d5d94b4e627"
    sha256 cellar: :any_skip_relocation, catalina:       "852846a202575170847907daaaa47205962825aa4c0ef37fb01f03e65d8c9c87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4895480808690bcea005067c13ce47f572ece5c209ea1d2765e9f30ec7976a6"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@1.1"
  end

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix if OS.linux?
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

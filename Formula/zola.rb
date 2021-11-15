class Zola < Formula
  desc "Fast static site generator in a single binary with everything built-in"
  homepage "https://www.getzola.org/"
  url "https://github.com/getzola/zola/archive/v0.14.1.tar.gz"
  sha256 "28e50071009a1430c5f8df94e2585d095f85f906f04101fe35ee9ed53c353cc4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bdc97c1e7b7902c6b07cc7743ebce62af4fcd2b20447c11791568bfff4c4df3f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5e420fb483377ec551235f9a7d269e8c9828af2658eca768ab6c2732e92dc20b"
    sha256 cellar: :any_skip_relocation, monterey:       "7796efc9d8d93b269f8de5ece4a96e120244dfbf00eb2f81670c4d047784002b"
    sha256 cellar: :any_skip_relocation, big_sur:        "5a49c5001b16f01f12295f9066dcda62c9e088ab781ee70787d2c7734422206b"
    sha256 cellar: :any_skip_relocation, catalina:       "ea76bba77f6b6752f303327ee2e10b246355f43f904596073edaed5259ecfaf4"
    sha256 cellar: :any_skip_relocation, mojave:         "5e553968c1abcd38fbde7ea397b6026f2fbb8843d69d5916eeaec7b01020d717"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a63250e7b1e0daa4975a931ab5f883f94c5c5cdb7edba6c46639428dc0567c9d"
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

class Zola < Formula
  desc "Fast static site generator in a single binary with everything built-in"
  homepage "https://www.getzola.org/"
  url "https://github.com/getzola/zola/archive/v0.16.1.tar.gz"
  sha256 "c153fd0cc1435930a4871165e6ad4865e3528465f3f41d0671a9837121688ac7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c61253251605ff8751e9c3198f3843bc9d18e582a9a7cbb8d2fe6e6aa7833496"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c08e6c88309de152f7a265da012dcb9823f1cbe5fbba77848b877bbd946cb1df"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2a46518e851b622f75ecb407a3c7e2be03ca5dedbbb1b28f70bbb8439c1c1bfd"
    sha256 cellar: :any_skip_relocation, ventura:        "8b045dd4de65f3d08d9e8a489b648812ef5bcd599071f7e8df8574ffa5495d11"
    sha256 cellar: :any_skip_relocation, monterey:       "f96375804c79ee2f6c6ce6403412a014b819f3432c170b9f8a6e27361886db79"
    sha256 cellar: :any_skip_relocation, big_sur:        "7c51958a5366ab917fc911e719e29b3a84f1bfd624ff8d2cfb66685667bc3af0"
    sha256 cellar: :any_skip_relocation, catalina:       "1bdac43bf87c55f43bbd1e85135673c870f90651b7948ea20c41c8a3a340b0f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "099dea7dde5fe17e0179b1b38a88c75845f7416df522dbd6e1fc3ebbc0520842"
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

class Zola < Formula
  desc "Fast static site generator in a single binary with everything built-in"
  homepage "https://www.getzola.org/"
  url "https://github.com/getzola/zola/archive/v0.15.3.tar.gz"
  sha256 "89a590549249e60a01f1a1f66ee23fedc711afd4e9a669ee1328e5c99ea958c8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "484ed75a7e0fe476838a0e22d6fa5951f555e73038a8ff4fdb1ce63ed916c8f1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c44647285e3bcefc042fa9b849bb76a15ee4da2f1e628b14f0598f7b83532928"
    sha256 cellar: :any_skip_relocation, monterey:       "f78e2b19a6e15679174f7e73cb25b5acedc9df6bc614bd516959f899e331891e"
    sha256 cellar: :any_skip_relocation, big_sur:        "48e5918533bad8f6f991a767277cb4bce47c49ced14b3a19adc5a037dccc1b10"
    sha256 cellar: :any_skip_relocation, catalina:       "ed0881b8ec633af70bc9e61a2d7b6f128be4d3235bced0c10b38984233f27799"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0b686f57d2bcf975daa5b350a7b84a5f9c5a916149e2d4b77620e4097991b9b"
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

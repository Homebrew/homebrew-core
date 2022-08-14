class Zola < Formula
  desc "Fast static site generator in a single binary with everything built-in"
  homepage "https://www.getzola.org/"
  url "https://github.com/getzola/zola/archive/v0.16.1.tar.gz"
  sha256 "c153fd0cc1435930a4871165e6ad4865e3528465f3f41d0671a9837121688ac7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a7e7fcf273e9278c89dd3d5be63d64b85cc9f1ed7154e9776fe8d397cec0ac11"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5ab3ed9f431decf8808065e32876df4150e1c15fa65c99ff2dc3c3510a470805"
    sha256 cellar: :any_skip_relocation, monterey:       "9bde7931286b6c622527f948e1accf0a2e00d722105ef0d8bb6dd9b361a137c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "34cbf42be25d08000e2918169bff997de69b263192bbc951b463bcd79037e66f"
    sha256 cellar: :any_skip_relocation, catalina:       "5c9c4ff1a9517b7c2ff742c5496be4f98333a7a62bdc6cbdc589ceb3eb541ab4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1e39a314568faecc92a6a464344e31174e2d4c9150d9206842c95f3146d5cfe"
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

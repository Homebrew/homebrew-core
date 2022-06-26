class Zola < Formula
  desc "Fast static site generator in a single binary with everything built-in"
  homepage "https://www.getzola.org/"
  url "https://github.com/getzola/zola/archive/v0.15.3.tar.gz"
  sha256 "89a590549249e60a01f1a1f66ee23fedc711afd4e9a669ee1328e5c99ea958c8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "63760f215220bd08487475ebaf4f80ab0b273bb55457edcc6b04b56caff5fb65"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "139d609fcfac6874762aa4d087c38408e2bae0b8c4ff01111503f64300a50aae"
    sha256 cellar: :any_skip_relocation, monterey:       "1a27978ece92ac0d189fb774c4eafb6001b7bace4a85530b3fe3e8843670ca65"
    sha256 cellar: :any_skip_relocation, big_sur:        "ebfaee43ae5ce7653c4efc97abbf9c26af1141443b4af31863236b684786b0fd"
    sha256 cellar: :any_skip_relocation, catalina:       "903262361a0baa26ceb1dd259e987b89cdc9404437138c891f3af40379c8de6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d4b9cd2103cc6584e1aeef9d2976a0f269f3feae4ce15edb454ad8740938984"
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

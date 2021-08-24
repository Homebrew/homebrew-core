class Zola < Formula
  desc "Fast static site generator in a single binary with everything built-in"
  homepage "https://www.getzola.org/"
  url "https://github.com/getzola/zola/archive/v0.14.1.tar.gz"
  sha256 "28e50071009a1430c5f8df94e2585d095f85f906f04101fe35ee9ed53c353cc4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1ca07c70636c4e522960376758427ccaf5ac06771fbd20c5dad4f9e0fbbd8d92"
    sha256 cellar: :any_skip_relocation, big_sur:       "5a192bd23baa5ca550f13f2e0d6886ee678f47eac3317268c72b10382c54fc03"
    sha256 cellar: :any_skip_relocation, catalina:      "d70e314ad7e829bbc6aa3a06cd7a0092cf957b8ec3bedc6f91eba6dfed402971"
    sha256 cellar: :any_skip_relocation, mojave:        "deb06f0987009ec46ed28b0c6ea7b1470f80ad84fbe44f62662833f949c973b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "764d1515f6d9d4402dfdbfe071b5b8c8a4987c8f0a86580e352bdd8e5209a0fe"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@1.1"
  end

  def install
    on_linux do
      ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix
    end
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

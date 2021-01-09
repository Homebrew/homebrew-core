class Zola < Formula
  desc "Fast static site generator in a single binary with everything built-in"
  homepage "https://www.getzola.org/"
  url "https://github.com/getzola/zola/archive/v0.13.0.tar.gz"
  sha256 "84c20cf5c851a465266c5cc343623752102c53929f6da31b2a4ce747a87c5c23"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "e8d389792c1a7c6f138738a44da557b8575a50832cd1b5fa3131d85ec47dd99d" => :big_sur
    sha256 "a16ab6a5bc7c04cf10f6266ce79921c607b6c19226190e65c420776595ed26d7" => :catalina
    sha256 "62c8164ec43c9c6090ff3be1b33ab2f2731894e626d2b2ac660b52f0f6902a36" => :mojave
    sha256 "4f726fe8708e96ab25f2830dfbb751ef67a34221621312604d6a2bd86bc87d72" => :high_sierra
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

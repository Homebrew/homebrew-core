class Zola < Formula
  desc "Fast static site generator in a single binary with everything built-in"
  homepage "https://www.getzola.org/"
  url "https://github.com/getzola/zola/archive/v0.15.0.tar.gz"
  sha256 "944e200a8ad5f4126ca08bbae576d1979b99755b554460f0f6fa3ba0924be30d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "358cd43ee01981dc2b344fcc8fe96ae180fac36b0926b2145085359ab2e8a814"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "581eaad6733df3dcc4dbebed9df55447bb32e7e2fc847cf6688aaca016eac040"
    sha256 cellar: :any_skip_relocation, monterey:       "89544b3105438d2c3235ccd86072777826f69d8ee08ac91097be397e49fb75de"
    sha256 cellar: :any_skip_relocation, big_sur:        "75190c5c0f0d52b1157cb2b32a399ea190ead18f2d807dc02687c67091b3d0a4"
    sha256 cellar: :any_skip_relocation, catalina:       "92a095f48b3810b1ba5ba3833ae5c4103a11c7333cc04812f524c6a32b09978e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "028a8912a6d99d808017f326f466e96e3e948d0880ee79fed819c484e25a0583"
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

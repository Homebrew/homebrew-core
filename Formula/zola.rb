class Zola < Formula
  desc "Fast static site generator in a single binary with everything built-in"
  homepage "https://www.getzola.org/"
  url "https://github.com/getzola/zola/archive/v0.17.0.tar.gz"
  sha256 "a7254554e61f2c737bc3981a6278e0fbac5dc685e5d90c014fc60eced99bf55c"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_ventura:  "89d9d4295d0e405ebc3ea2035974b9221cf12711ac72d0c518f078a0894a1eed"
    sha256 cellar: :any,                 arm64_monterey: "1254587c6c0fb421a6d1209de41530a5fc41e8bea240fe37d5ddc1cc86e7ea7b"
    sha256 cellar: :any,                 arm64_big_sur:  "127d6a120df4d4fb5298c645a66ab956255cb2b38c031c94ae3040d4b1b0bd6e"
    sha256 cellar: :any,                 ventura:        "20495c0b33e03b214e32bca0136bdac8746978893201a48a7dfa52440736d3ab"
    sha256 cellar: :any,                 monterey:       "bae23b7e40aa396aea13d0732fe96ac915cad05605bfc392c9ac988afa27f57f"
    sha256 cellar: :any,                 big_sur:        "54b1fb1bcbb4c6bfde0a3f035b7e97f794a7547b2385f0feb8c4cbf999a542b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e081a32aa135535a946470a38ee473002aede9c3bb0ddd1afe58a5c935376952"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "oniguruma" # for onig_sys

  on_linux do
    depends_on "openssl@3" # Uses Secure Transport on macOS
  end

  def install
    ENV["RUSTONIG_SYSTEM_LIBONIG"] = "1"
    system "cargo", "install", "--features", "native-tls", *std_cargo_args

    generate_completions_from_executable(bin/"zola", "completion")
  end

  test do
    system "yes '' | #{bin}/zola init mysite"
    (testpath/"mysite/content/blog/_index.md").write <<~EOS
      +++
      +++

      Hi I'm Homebrew.
    EOS
    (testpath/"mysite/templates/section.html").write <<~EOS
      {{ section.content | safe }}
    EOS

    cd testpath/"mysite" do
      system bin/"zola", "build"
    end

    assert_equal "<p>Hi I'm Homebrew.</p>",
      (testpath/"mysite/public/blog/index.html").read.strip
  end
end

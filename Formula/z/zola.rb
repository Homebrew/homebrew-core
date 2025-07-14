class Zola < Formula
  desc "Fast static site generator in a single binary with everything built-in"
  homepage "https://www.getzola.org/"
  url "https://github.com/getzola/zola/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "ed0274b4139e5ebae1bfac045a635d952e50dc238fdc39cb730b032167f8bb4a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b0602145729f6ad78e1f7a4be7eafda94f105af40fea8c199ca45f51d092b4a9"
    sha256 cellar: :any,                 arm64_sonoma:  "7397bf10428065a5040d42fe0d5b3939ea3f5cf129d682847b5e4bc3f789367f"
    sha256 cellar: :any,                 arm64_ventura: "df9ccd75dc1889c7aed9f7ba990ab73478764d7b8e848762ceb109e212738f45"
    sha256 cellar: :any,                 sonoma:        "4026f1af866280ebdc03a0ff0d58875b66ceaa6c0983d01e9826b94af5b54586"
    sha256 cellar: :any,                 ventura:       "0e82e5262375333fd60e053a3765d89a2af8f2ff714b02aadd07e6121077fad3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1b22c7054e144b538a896eb7a93ee75c3b795741b8dff69e8162baac1c317bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29df2af104972ca53f558d0a48405057165fced8fb4ad167a5b73378c439d271"
  end

  depends_on "pkgconf" => :build
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
    (testpath/"mysite/content/blog/_index.md").write <<~MARKDOWN
      +++
      +++

      Hi I'm Homebrew.
    MARKDOWN
    (testpath/"mysite/templates/section.html").write <<~HTML
      {{ section.content | safe }}
    HTML

    cd testpath/"mysite" do
      system bin/"zola", "build"
    end

    assert_equal "<p>Hi I'm Homebrew.</p>",
      (testpath/"mysite/public/blog/index.html").read.strip
  end
end

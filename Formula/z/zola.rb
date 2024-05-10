class Zola < Formula
  desc "Fast static site generator in a single binary with everything built-in"
  homepage "https://www.getzola.org/"
  url "https://github.com/getzola/zola/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "c0e1711a68bc005c2e0ecc76a468f3459739c9e54af34850cb725d04391e19b5"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "706543efe5f32db0ff1023aab7f328840063cb9a2593b5542dc1b7f1789305db"
    sha256 cellar: :any,                 arm64_ventura:  "f8409ef328f001e5fa4353d9d28ecb8696a9facc070b1d8e33e0fa92d3706c19"
    sha256 cellar: :any,                 arm64_monterey: "53bdd6614e4a9e27baf2d0f05b39218d27c84748e786357b1408272e8328bf2a"
    sha256 cellar: :any,                 sonoma:         "2850406d66a619b2d2a51360be5c1f7c54aa882f8d0a2291f86953480870dff0"
    sha256 cellar: :any,                 ventura:        "8dcacfaaaca73e8f820006997350f86d02be3b2ebc20890ae7655593b62ce12b"
    sha256 cellar: :any,                 monterey:       "a6e05f121e0bb85dbee8fc6f257b7afce67ba19cadb6e1cd62a06068b8a7788f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5fcbc5ce0a3118cff8b9fd322736cb75b411984b276d3f24b5ed3904b6b854e8"
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

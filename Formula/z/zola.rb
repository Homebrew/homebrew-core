class Zola < Formula
  desc "Fast static site generator in a single binary with everything built-in"
  homepage "https://www.getzola.org/"
  url "https://github.com/getzola/zola/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "75274ca54c97da2f24645568e2c7024f6661ce002e8f7e09d6cd30bae7b73b0a"
  license "EUPL-1.2"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "833c402617f8d87a703d570bb2271cf2866eb7dfae9b61d1fe69aa2f759b161c"
    sha256 cellar: :any,                 arm64_sequoia: "cf76ab9e59615c7452d10ea7da85d5415d5dceaa17860d4d18a4ba3b3857350d"
    sha256 cellar: :any,                 arm64_sonoma:  "34f385ef819cd92681906ae55636274daceda8b6a29d0173e14c763f23bcd4cb"
    sha256 cellar: :any,                 sonoma:        "596e81b4e324a33477bcb502198db8a6b3779c85357270953b2cd1f3f92fdfb0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "064cbbb81fce30143a03e6a62a6f83f78a5d9f093c3edd302c1b44ac74616882"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2877a9b0999089d82b58ef88f9f60f72439b08d89963dd86004b190bbac8f338"
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

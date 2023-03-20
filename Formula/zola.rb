class Zola < Formula
  desc "Fast static site generator in a single binary with everything built-in"
  homepage "https://www.getzola.org/"
  url "https://github.com/getzola/zola/archive/v0.17.2.tar.gz"
  sha256 "471238f38076803cb2af1c53cf418280ae51694fbcc2e547da3f6715a718c750"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d36813c40954ed985cef2520dca95e49becc41f880b9b642b2326a0da5b5c13f"
    sha256 cellar: :any,                 arm64_monterey: "c876116273dc900bb62e9b3486763f84d5e5b4fafa22b66b20a069318a16ec5c"
    sha256 cellar: :any,                 arm64_big_sur:  "294724582d39eb38875e0f987b047fa16135e69f75ad244f4efc1f23d437031f"
    sha256 cellar: :any,                 ventura:        "07cc0ec3d3357148a56719b37c6d64fe643b6bbfc5318b78b44251f2af1bf642"
    sha256 cellar: :any,                 monterey:       "0e86e27b20b41535612d1852e76f8d735576f3ebc2a094976058b7e315407775"
    sha256 cellar: :any,                 big_sur:        "f9ac7a148debb0a5c7acf87a3e704f53c33264a3db2e99f265b7353b129c61ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1466739a0d057299b0bc40304936762cd802d47fc255d99ab03391cd9fc28cf"
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

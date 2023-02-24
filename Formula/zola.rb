class Zola < Formula
  desc "Fast static site generator in a single binary with everything built-in"
  homepage "https://www.getzola.org/"
  url "https://github.com/getzola/zola/archive/v0.17.1.tar.gz"
  sha256 "ac58dd9d43b134d416bb29c19980bbcbbb9dd552c1ade69c72239df2128565d3"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "899dbfde2dab83f023b97e31e53fdc8cf5b926f58c7d14de38cef67d7a570f19"
    sha256 cellar: :any,                 arm64_monterey: "a3e47b9ed2033a9ee57d9c61a39274cd748639344f9c03b12c66c8babd633f67"
    sha256 cellar: :any,                 arm64_big_sur:  "82e9f31ce4e51e1ff1c2b534a4168026f1519d596cdf1ff770417be84adc5958"
    sha256 cellar: :any,                 ventura:        "90299893eeb513c716d217b75d7226bfaebf9cb9812f9d945c71cb7febd409f3"
    sha256 cellar: :any,                 monterey:       "1c62ba0f00b9272855f6f8a2e28cde4a57ba241372857441579f568c5b6e092c"
    sha256 cellar: :any,                 big_sur:        "7a8400732bae7b27befdb8d91ade697fd5aa32f49d175b5f9d98597448623c6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f1682f5d328963696b24e1102d3b2cb941c254d81c2ed9710d7ab8402373340"
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

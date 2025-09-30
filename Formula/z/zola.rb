class Zola < Formula
  desc "Fast static site generator in a single binary with everything built-in"
  homepage "https://www.getzola.org/"
  url "https://github.com/getzola/zola/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "bbfbc0496cf6612b6030c6d97b0fd2567f5ec41e251f8874b6c9ccda4c8149d4"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "08b28342f63cc3ccd3d6de9a6cab99dea3fecfba6a3a57fd597fcf08d3f63f23"
    sha256 cellar: :any,                 arm64_sequoia: "c71a07f6ae400da7efa06078f253e8fddeb0764a552adcd4997bc5e3d970b541"
    sha256 cellar: :any,                 arm64_sonoma:  "8e1da1799c111f7a55d363bb78d19af4b401f0f36d470ec0734fa95ab3a48439"
    sha256 cellar: :any,                 arm64_ventura: "22a3061287a22af643bb6717caa0cf0d0ec3acc3d0fd8eb0d966a707d992d80e"
    sha256 cellar: :any,                 sonoma:        "a2518b3d85cd8d05ef050333ba8d130513d83d08b0324068ce5606a510294bf4"
    sha256 cellar: :any,                 ventura:       "fcb14116063f863b1efec1ec099091c6f52381373957a64365ddfd26d273712a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1592c72ce75c49bced0ef6e0be212de3c720e78f8a8582bf4f0d6909c60ee4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d964f4df791aa67dc4fd42514077eae08ef884b3ea55d5aadffc7689d874b72"
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

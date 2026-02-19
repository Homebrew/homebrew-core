class Zola < Formula
  desc "Fast static site generator in a single binary with everything built-in"
  homepage "https://www.getzola.org/"
  url "https://github.com/getzola/zola/archive/refs/tags/v0.22.1.tar.gz"
  sha256 "0f59479e05bce79e8d5860dc7e807ea818986094469ed8bf0bb46588ade95982"
  license "EUPL-1.2"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d0b4f6dcd6f93092e5d6b7c5523d4708542371a56983805abd7c63331ed1eac5"
    sha256 cellar: :any,                 arm64_sequoia: "5ef5e79cc049d96c6ed8e203a104e66471aad1e61303d595ab3b2c5907033d2e"
    sha256 cellar: :any,                 arm64_sonoma:  "ad449dec819db4ee40826148692be8392eaa8694cbba236646ccd9f292885070"
    sha256 cellar: :any,                 sonoma:        "acdcc9fec950ac9c5a109cbedaf4dd57bd6a5aaaf1ace613f84a35db23740c2c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "85106de0bbb3f42628d011213df85a1ca705d785fe2dfa50bc0d7ad72d23ae23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd1481a6f76baf68adfac5b59d3df2db3027ec32cb0bd526dcd7583e41fe007e"
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

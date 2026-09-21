class Zola < Formula
  desc "Fast static site generator in a single binary with everything built-in"
  homepage "https://www.getzola.org/"
  url "https://github.com/getzola/zola/archive/refs/tags/v0.23.6.tar.gz"
  sha256 "193db594222cd9c1097387ce17272cbbe672c3a894c263f6f4c436a7fedb379f"
  license "EUPL-1.2"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "92e4acf1fa8fc374c2f11ab5a520109caf8c3b10ea2b77a13b4506e71001ba31"
    sha256 cellar: :any, arm64_tahoe:       "3fa67cf51efc3cf051c748996fd0150b77236bd2894dbf23431e4da21d340667"
    sha256 cellar: :any, arm64_sequoia:     "f47d002fe11ff674a3f2ec84c01525ee253a567acd7c2e6b6ef2749c7418f455"
    sha256 cellar: :any, arm64_linux:       "981765219eae043318ba70cd7ec7ecbbd9ff57e648a9c29f7000218a7918d69a"
    sha256 cellar: :any, x86_64_linux:      "2ed0144800d0c72f51a74c456d8e30e5e5fbc3a7837d932a764e466f9a3f51b2"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "oniguruma" # for onig_sys

  on_linux do
    depends_on "openssl@3" # Uses Secure Transport on macOS
  end

  def install
    ENV["RUSTONIG_SYSTEM_LIBONIG"] = "1"
    system "cargo", "install", *std_cargo_args

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

class Zola < Formula
  desc "Fast static site generator in a single binary with everything built-in"
  homepage "https://www.getzola.org/"
  url "https://github.com/getzola/zola/archive/refs/tags/v0.19.2.tar.gz"
  sha256 "bae10101b4afff203f781702deeb0a60d3ab0c9f0c7a616a7c1e0c504c33c93f"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "4d79830a96d63b13b20a05393bf1c194e6d0b66f56e35afe53257d284cf09a25"
    sha256 cellar: :any,                 arm64_sonoma:   "72884ca2fcf1d9eb26232eacb7efc63597b801e4913b7acffc7feae396357ed5"
    sha256 cellar: :any,                 arm64_ventura:  "8a28ce287dcc749f5e812497c440ca7a5d6a2106edc88f2dbb196c5af811ffd4"
    sha256 cellar: :any,                 arm64_monterey: "ddb05cbd1b7fe5748812a1033b8c0f7f8377108fdfef24446a5c24c792bb6805"
    sha256 cellar: :any,                 sonoma:         "5e1e6570eb4082022a4e66a7afd7e37121b45515e424d7eaa9ff6461b5353c69"
    sha256 cellar: :any,                 ventura:        "cdccf85bcced67724481b34256bc4670031c3e173b4196fdde3f3bf7e648cc35"
    sha256 cellar: :any,                 monterey:       "f220936fb8f77a80d66dc6bac486c95039abe1f498de0c2edaa70a8113714b49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d6138aa7ff35d309d8c8a3c17ab9552bb8b9465427701fc7cf5d869c2c6e940"
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

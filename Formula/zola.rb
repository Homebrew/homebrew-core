class Zola < Formula
  desc "Fast static site generator in a single binary with everything built-in"
  homepage "https://www.getzola.org/"
  url "https://github.com/getzola/zola/archive/v0.16.1.tar.gz"
  sha256 "c153fd0cc1435930a4871165e6ad4865e3528465f3f41d0671a9837121688ac7"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "745cf51a531ba4f32b54a6f1a871586e06a61006dbfeecb06724f1541f068039"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "40487210c9f3e7df0359c0717717a824ed181fd00313e3434b1b670a8cdbacb0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0072604ec0763a9807cef530ca396ca21349c3994d3e4b09053fa3cfce660ae5"
    sha256 cellar: :any_skip_relocation, ventura:        "9849137582ef3a4d8d67e15a4f80b2dfc88fa2c43feb425a97b70da76ae47690"
    sha256 cellar: :any_skip_relocation, monterey:       "b56c6f2b926bdd873f3f1a2ff184f8b8140dda268d42c13297d1ce965a454a77"
    sha256 cellar: :any_skip_relocation, big_sur:        "913c41c78e92dfec5b46b7733679892d42967dae731787df7332ac7cd4ca2746"
    sha256 cellar: :any_skip_relocation, catalina:       "3663e5809c701cefcaaf1eb734011fac816fb7eb7d96d2ede3dcba6fabdcee4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b185e33df9ce30f79b8a0501d4fe871bc8005f2dbdd115408c14bc3bb59845a1"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@1.1"
  end

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix if OS.linux?
    system "cargo", "install", *std_cargo_args

    bash_completion.install "completions/zola.bash"
    zsh_completion.install "completions/_zola"
    fish_completion.install "completions/zola.fish"
  end

  test do
    system "yes '' | #{bin}/zola init mysite"
    (testpath/"mysite/content/blog/index.md").write <<~EOS
      +++
      +++

      Hi I'm Homebrew.
    EOS
    (testpath/"mysite/templates/page.html").write <<~EOS
      {{ page.content | safe }}
    EOS

    cd testpath/"mysite" do
      system bin/"zola", "build"
    end

    assert_equal "<p>Hi I'm Homebrew.</p>",
      (testpath/"mysite/public/blog/index.html").read.strip
  end
end

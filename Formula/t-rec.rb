class TRec < Formula
  desc "Blazingly fast terminal recorder that generates animated gif images for the web"
  homepage "https://github.com/sassman/t-rec-rs"
  url "https://github.com/sassman/t-rec-rs/archive/v0.7.5.tar.gz"
  sha256 "384230f2246a869cd8132a8fa7663051c1b4d5786a27cd34e184f837b8d5c5d8"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b7d9f0e3c8706a98d91d9ef24bffaff8d7840bc6f82c9b19c47020f4eafe93c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d6caa476f9869ed960c23d6471f1fb6fd31181c14746d4a59bef00f162b339e4"
    sha256 cellar: :any_skip_relocation, monterey:       "78fbf9c6db61e970395ad30cf10b9d845c800329ea8f60d0b484a7d8fc795803"
    sha256 cellar: :any_skip_relocation, big_sur:        "53674c3659a7915b8f410517a2fbb4c95d5b82f2b5c92838c8850df2202f2636"
    sha256 cellar: :any_skip_relocation, catalina:       "9fecb32f33a88a62f903f20b1b83c6eaab61681f3812a0a2c4c86356cfbbf723"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aff882605d28bcac69324c473bfb763141367fb920b77e778be8bb7a9b454d0f"
  end

  depends_on "rust" => :build
  depends_on "imagemagick"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    o = shell_output("WINDOWID=999999 #{bin}/t-rec 2>&1", 1).strip
    if OS.mac?
      assert_equal "Error: Cannot grab screenshot from CGDisplay of window id 999999", o
    else
      assert_equal "Error: Display parsing error", o
    end
  end
end

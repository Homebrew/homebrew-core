class TRec < Formula
  desc "Blazingly fast terminal recorder that generates animated gif images for the web"
  homepage "https://github.com/sassman/t-rec-rs"
  url "https://github.com/sassman/t-rec-rs/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "3b008a13d773807d3ce92ff296106c779bea7f57b9bd6d6a5530f7159980cb7c"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c6770bc2d31a55cb9965b215d6ec092dfe874cfe6f19f65f105e1a76cce66124"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "badc62f87e9a3f0ba51a4ddf2ffaedd3cc1181e002a00b4b19b00f0cfd40c429"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07ae2a1d587f45a4d349d973dc314b513029df01ac7233219ec62bb88654a5d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "b8b245ce74ecf57b1d93ecbcf2656387bc5e5e06782aed7014c3ca2de06b3507"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc683a51a96e0273efbc4b9c558634bd36ae04eee47072bdf8d180c88f15a5cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6b7b2dfd91f0eac21c26bcde05a8af483354f3ea9cd5f1d89a39795753e37fd"
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
      assert_equal "Error: $DISPLAY variable not set and no value was provided explicitly", o
    end
  end
end

class TRec < Formula
  desc "Blazingly fast terminal recorder that generates animated gif images for the web"
  homepage "https://github.com/sassman/t-rec-rs"
  url "https://github.com/sassman/t-rec-rs/archive/v0.7.1.tar.gz"
  sha256 "4bb96caefa7476607f65b4582da9317e7d8afcded5bcbb3a99839bccd81a52ba"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cfff7da1f56eaca62aaa2e27dd35e71e66553ae2d7c41caa0ca0150da6216bf2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "31d4d0be86295ff08fce1d2c8235271a2706767eb152cf677de594c745f946a2"
    sha256 cellar: :any_skip_relocation, monterey:       "f21631da76eef32d3bc8f9831344d73aca25fae2f915cf78aa1a4759cc35f46d"
    sha256 cellar: :any_skip_relocation, big_sur:        "45dbc89105d598e67e1e9f55779a5f98244e651d05c0d36d761ff653befb9210"
    sha256 cellar: :any_skip_relocation, catalina:       "96a217c4649c7ff1316c6704785d88a6db45378b3534bc09e3caa04c904d3b70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a36310fb1f5d6dbe42448dbf822810e23d1838967ac2f94bed719401b0cc4082"
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

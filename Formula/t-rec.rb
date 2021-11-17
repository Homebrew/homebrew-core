class TRec < Formula
  desc "Blazingly fast terminal recorder that generates animated gif images for the web"
  homepage "https://github.com/sassman/t-rec-rs"
  url "https://github.com/sassman/t-rec-rs/archive/v0.6.1.tar.gz"
  sha256 "ffbfd854bafe29e47dceadaf615e2d09cc64032396ebe90409601ec91967cbc7"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13d00a27d7d5f540d0b661c2cd7e44eca97571e58ad7c0427dd01dc85e266bb2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4e73804c904818fd02abfbd36a6a08c13239f35551c61527efebb68a0a35069a"
    sha256 cellar: :any_skip_relocation, monterey:       "c2bcd2efe27a61865935c6360f69af432bc1a3cd3a0aa3d35a525a290368a348"
    sha256 cellar: :any_skip_relocation, big_sur:        "77c8c3e8b56d0b2c2e3d6e3c151d7bed827785f095e6289b232fd037c28d69d8"
    sha256 cellar: :any_skip_relocation, catalina:       "a68743209139f17b63fca209046b59b3eec18cf1fb4e97ff0ddcf6ee56c1cf6a"
    sha256 cellar: :any_skip_relocation, mojave:         "49975277f0afd12af94810a14dce5b5ddc9734d8d5dcb26c48652671efa4c38f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5fac6fd3bbd2f96be50814d9fe45de00cc657f2bc602ac3da67ed5741cc6f0f0"
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

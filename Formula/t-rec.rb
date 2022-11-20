class TRec < Formula
  desc "Blazingly fast terminal recorder that generates animated gif images for the web"
  homepage "https://github.com/sassman/t-rec-rs"
  url "https://github.com/sassman/t-rec-rs/archive/v0.7.5.tar.gz"
  sha256 "384230f2246a869cd8132a8fa7663051c1b4d5786a27cd34e184f837b8d5c5d8"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "72d31a1b73c2a3c4a9107be704a910fdf302ecbfc5b68795a253e0ed383767ce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed68d59b8c44bbe9f61703ec48a509b37016c3e9d4259e88a3a8be67521f41d5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9dc160993cf6715e05a1286bb888eb1703b1da261c8f43ec29109271a40e153a"
    sha256 cellar: :any_skip_relocation, ventura:        "96f6a8e6b8067b2f88d9111223d212265760690df0ecd73624855a7a8d10e304"
    sha256 cellar: :any_skip_relocation, monterey:       "2adc34152d4b1b50b314778d5236906e5e07f4e31232a45a3302c1a64abcd191"
    sha256 cellar: :any_skip_relocation, big_sur:        "ca333ea15d2e13356c245d293ae241f2a855240ee851ee70112cf444edd2a682"
    sha256 cellar: :any_skip_relocation, catalina:       "8a4093d1a9512e2b09cdacb726a38fede7e84f74e20985aad5d243c4144ea112"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f035ede2751d186b99c826a7727a90b83a71aa4e4c9961b695e56aa586f34541"
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

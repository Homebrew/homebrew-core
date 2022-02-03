class TRec < Formula
  desc "Blazingly fast terminal recorder that generates animated gif images for the web"
  homepage "https://github.com/sassman/t-rec-rs"
  url "https://github.com/sassman/t-rec-rs/archive/v0.7.0.tar.gz"
  sha256 "f5830896bd8829061619916af5400a3a5fa974ab88d2c6631094116bd11e48a1"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c052439df721dd53c46d20f21aa41020dbb888fa055011a8062d9fc3d5a2c87"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "603799fd2e15d6648aca52bafe05acb6080b9393c7d08cb3150d51925ae1c642"
    sha256 cellar: :any_skip_relocation, monterey:       "d4f6bd99d824977f78c75abb6656f2308f4d499535e631ef64467eb2bd52281c"
    sha256 cellar: :any_skip_relocation, big_sur:        "8a5defb7fca8e7ab14917db19fbc399c80dc76324de615ff54ab9aacd4c535af"
    sha256 cellar: :any_skip_relocation, catalina:       "92ac6a8a7fc95f138bb0df69dd44c384f79e7fec2a31d4e39e063dab5f41b17b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84fa4ceb8d13057499aa2d51b654b6ea5e4a5dbaff0aacf34193a222ca4d2b10"
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

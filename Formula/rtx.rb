class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://github.com/jdxcode/rtx/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "4b8d6fa3de8306cf6a54529a07d01d17d78605c5934d8a3be1d2e8dbcbfa8309"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c1798d7cee58b5a0c7078f8d5cd8b28b65eb69dad54b129bc84d60bd7e8df6d7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66901af3a7897148788911546f837decd4b1cd5c17d1b1395bcb11e407876377"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c3895cc1d1f21267de512c922aa9ed67931790409055ccc812a4db66bb938101"
    sha256 cellar: :any_skip_relocation, ventura:        "a35da4f245a32f883c1b5ca6cdbd55e8747676471fb7242978deb590162c751f"
    sha256 cellar: :any_skip_relocation, monterey:       "3d24ec88a6a2dde24075fde18cdcea98a87fb9d723e3d5d34ffee660e9902c68"
    sha256 cellar: :any_skip_relocation, big_sur:        "835a419189ed8ca90d0375cd646510ec73e4395bcddb3d51887b1eb55fcc9654"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df2c1b36d16a2682378016aa97278b853ce58a988b53a6a77f1fb15428342610"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/rtx", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}/rtx exec nodejs@18.13.0 -- node -v")
  end
end

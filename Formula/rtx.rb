class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://github.com/jdxcode/rtx/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "033bc2488bdf35723d7c2addcf21796964269602b1dc2d710b67adfaf1d4631a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d75d042e5c5025908153a4245a7ac91a66dac842ba9393de9a6165e95eaa9f09"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6db059aa5ea873fcbe9e69d5d9d78894cd1dda99642bfb0c1713ca0fa6a05e1d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "99549d263482c9696484d2ad902daf747ab71787069a1ba6f16b36365ee3c65f"
    sha256 cellar: :any_skip_relocation, ventura:        "c02c02129970de249de1e609751dde582933e3f50bd5f254e5e036542379e6ec"
    sha256 cellar: :any_skip_relocation, monterey:       "c670f44c3bf4cb8e7fa153ab7e6a821b345ece58624a72b9fb578e78eb60c989"
    sha256 cellar: :any_skip_relocation, big_sur:        "c8ef917d10a05d2a4ff8898ee0a0878af84cf4fe358d7dc7fbccac67816bb174"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "349ae0f67618a69a3c6878826ede55e5e5ea984ffe7f2b9d68ee1450030f1985"
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

class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://github.com/jdxcode/rtx/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "8be4050ba77ac368eda6c3481116332515b9e83348cecb37ec241f58914c4d56"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b10ba8367e715f21a73ed0353ef9d6aaa947289075a7ecea10b30b777af5bc99"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f8f312d16ee083eaeb8b95c46e969a2513477fa6be44f82d105681e3b6c69d6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "06dfa240bb293922752d0dbe9e38af9eab0459153e7334dd6b1a0838fb16b1d4"
    sha256 cellar: :any_skip_relocation, ventura:        "a03dcf6ced60f71e2cbe89b542c5862f5cd8c492615cf4374af406822eae67c9"
    sha256 cellar: :any_skip_relocation, monterey:       "94d4efd066f1205ec45073321872d520abf27b8d654600da416258f536b9586d"
    sha256 cellar: :any_skip_relocation, big_sur:        "dbce27ac44fed1359beb6558930e3a4cfd2d65674ffa69e981442c3c6cab802b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7d64eeb7655a981c7c4c1788ac34367b477649f2c43d633bb85378096e4d383"
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

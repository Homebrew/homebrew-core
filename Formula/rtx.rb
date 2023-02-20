class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://github.com/jdxcode/rtx/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "bdeac161e666d1ef90559a7e648746abdea17b39aacd1cb098736dcde3e43974"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "80d0c4546cde4cef3ee83839bb2450505de932f745a2d0cd8a60bdf00053b341"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b6caf3c6b41432169421758fa0187631f8df4bdb87d70fd4a9604efd2b44411"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "62d66c30a2243ba48a375ae17f6eb66624be921122252a50f99dc9dcca7bb9d4"
    sha256 cellar: :any_skip_relocation, ventura:        "c94472398e4579c16ec59a5c286f539fcfd19f5b5a2d434a7d036d9db2897128"
    sha256 cellar: :any_skip_relocation, monterey:       "29764e7bbd37d556ca8ad66596565f170bff792ad58006df5a604bff440b2e13"
    sha256 cellar: :any_skip_relocation, big_sur:        "6aab6491099accb86a77598a37514e54e0b656a38dbd683ceab7bbad842551da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44f801f6df8bf0db589b153c2534e5d63b5f2448331f0804af0ac390b7b7d8dd"
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

class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://github.com/jdxcode/rtx/archive/refs/tags/v1.32.4.tar.gz"
  sha256 "58a78b61086a43c6921f5ed46dc3d3df39210d060f5de920981292f4608b7fff"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9e6afd247a0f383f56dec09e4dc0f3469535b1e92c7ff17b286846dbf11369fd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93030079a0fa8eef9c303bf24fbf26507c73e9ec340bf7d7da91519ea13e4f5a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa615e6c91c34fbddd859646172f4b4f79625ffee26e98d8d5a5eb9448f3fd6d"
    sha256 cellar: :any_skip_relocation, ventura:        "01a401db2811ef0383a487a8b4ff9e49a7c7ab75d8aa6c90de15d4742cf9a5be"
    sha256 cellar: :any_skip_relocation, monterey:       "eba675c3ef2eb317340b0718a846fc6630a92a644c48eb76bfbd6fd4e7cdf52a"
    sha256 cellar: :any_skip_relocation, big_sur:        "80ec6be6e8746e6915f5d21dd36c24b80f3ea2477570c66641b06ce5316d04a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2499aa57a1dfd45e820e3547aa39399e55498ae0549bc933a207331a42ca2c73"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features=brew", *std_cargo_args
    man1.install "man/man1/rtx.1"
    generate_completions_from_executable(bin/"rtx", "completion")
  end

  test do
    system "#{bin}/rtx", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}/rtx exec nodejs@18.13.0 -- node -v")
  end
end

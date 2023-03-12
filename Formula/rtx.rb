class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://github.com/jdxcode/rtx/archive/refs/tags/v1.23.3.tar.gz"
  sha256 "28272e12480ed53ee2760bb79b2e6f720bbaf0f22e2d22ca1105345bb0242b92"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7781f1f7fdce8f22a4e8c561f56209d53884f7576106ab7222a9cc14248ae77c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8fa95195df8a22cd5a8c0e605b635f3daf1e80853d4ef8e92cac49b1888f48f5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a1b87c0c3868c9d951d8b6da030c336ba3fff52ec7d77dfbf0c4922dc138d966"
    sha256 cellar: :any_skip_relocation, ventura:        "170d26d34e084cb194c8dadbd63392cb18da3c7f1482da1e45729676ae7fcc5e"
    sha256 cellar: :any_skip_relocation, monterey:       "7f92b6ad16f367c9f339fc77b73dafad856d64ff6cc9aa8ada419c4f70ad534c"
    sha256 cellar: :any_skip_relocation, big_sur:        "9396a966f47c8bf2cb52a6f880b2f1a836b77cdfec05f61cf7d6206303a8039c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e1cc080de068835c40cedc83b9f32652ff3db08df6179624dbdf5941e634481"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features=brew", *std_cargo_args
    man1.install "man/man1/rtx.1"
    generate_completions_from_executable(bin/"rtx", "complete", "--shell")
  end

  test do
    system "#{bin}/rtx", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}/rtx exec nodejs@18.13.0 -- node -v")
  end
end

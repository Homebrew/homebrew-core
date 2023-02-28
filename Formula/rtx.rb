class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://github.com/jdxcode/rtx/archive/refs/tags/v1.19.1.tar.gz"
  sha256 "8999ea9be21d6a0b9fe9bd8d8a0e63ef51adcf1c2d3014bdc415f696dccb7a5c"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aaa5f285f80cd812c9f531d54c0852d510dce8385650b955310a3dc42b27b584"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "740b09da798688cde4025abf65b710db7464041d546fcb202209df5f93ba9bec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d685c5979a909204eec30c1d9faa5ed96adb97178018f1b62bb2e071d68de5b6"
    sha256 cellar: :any_skip_relocation, ventura:        "c758a07aa9bcf0cb5d1ca6e627da62b350fa457295899d4e53a4979bdb21c497"
    sha256 cellar: :any_skip_relocation, monterey:       "304d8ead57474db835673d3ae8a552bd93013068f573947a4296bc72f6b15b14"
    sha256 cellar: :any_skip_relocation, big_sur:        "7e71a895896d25e07e7f5ac956e4f85e23e80dfd23ad4797cf058eb25f95f38a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "685cd55ebb7deff0d8942fee7ea1e1f3104146383254720330f7a0564d97c759"
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

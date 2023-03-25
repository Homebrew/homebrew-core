class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://github.com/jdxcode/rtx/archive/refs/tags/v1.27.7.tar.gz"
  sha256 "708040a948a278fbcd1a987babbe005c93fb77514099fc3df75d296391095c70"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "857f6a3a209adef90fc7b2f41745e02bfc7ed1ff24096e0adfc2b795dcf230ad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "30c4b1854d3c6ba5d1797377e2ddcddee5856b9057f555a9fac31d495a3664a5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4a409d04826a8e8dbdabeb0883cbe007ad7e30db86c26bf81cca968f5e594d35"
    sha256 cellar: :any_skip_relocation, ventura:        "86e44f3f28365d399653e16443d7ed8ef69b497389a211c26cb97b2fba6b83fc"
    sha256 cellar: :any_skip_relocation, monterey:       "cecf8b7ef955cf33b53422bb6f07476bce870e27db209bcd42b3d2c8681a553a"
    sha256 cellar: :any_skip_relocation, big_sur:        "7e495e4b0f2617613eca9617b5a98b6397b50b0c7acc3e47f4319433d6ae4213"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0b177e7760e1669ea6aaca5aaf68733aec723024b168bbdbfe202d4012a16b5"
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

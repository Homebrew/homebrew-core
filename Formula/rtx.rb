class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://github.com/jdxcode/rtx/archive/refs/tags/v1.22.7.tar.gz"
  sha256 "9dd1376d491aa813bb8e27940254b9938c6a6a791ac86623c46189fd56c11bc7"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f346cebf65a51894cd5b2e09bc993715fe9dd6704945510707b42194213dcdc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f4675c946e597bb0f4e3110b4e6c269323736930d9a9ebb9b909bf2fd6e2cde"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8a3c2bcfbe217818124f3483c1f4c7f84722df6ce2bf768578d812fb43f664fc"
    sha256 cellar: :any_skip_relocation, ventura:        "a6ca248615fc48181b4a72be24026378135eb686f6438332984836e24ce88585"
    sha256 cellar: :any_skip_relocation, monterey:       "18c6862a6e65fbd3806f0acee5b0a4fe0fde97c1e0f7f0cfe859ba28d428ddbe"
    sha256 cellar: :any_skip_relocation, big_sur:        "d72e5adb9cc867676b4481d3698f4f30554f66a0157cd2b6d3f1d27a4f65b4f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10f35657b68eeb9e2bf69fdbca80e117dcad127fd05017d1acffbf36df1909f4"
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

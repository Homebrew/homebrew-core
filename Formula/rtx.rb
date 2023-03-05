class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://github.com/jdxcode/rtx/archive/refs/tags/v1.21.6.tar.gz"
  sha256 "d8a4db1887a95d6d9d6d668cb9735c19fad6b869ee5b9d36d3c2ba4d96e4e5d4"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a46e85baf940329624ad05e2a722cdcd2cc6b8b07f53343d8ac459671aecde26"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca74525a4497f6d9a60935989772300d8caca09ae95eb3d9ae7691861b147200"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "193b401f6bb1de88fc42358aaa192a886c39df6745dffec470b032589a8384e0"
    sha256 cellar: :any_skip_relocation, ventura:        "0fe71fa15f4a9fae71da8068fee9b8d22c19af5073fc205399f7ea40fc4a7120"
    sha256 cellar: :any_skip_relocation, monterey:       "7e4ac8061404bd5954a30cc48c99e3c906f2d555c0d46adc90848784af88de6a"
    sha256 cellar: :any_skip_relocation, big_sur:        "4c509f7f80912a71b0f1cefe547df8ebfbce935a24bfa5568405723887455af5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72318420517c3225aa5f49944d981239e90b62ac77e320f07a859941bc29743e"
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

class Xh < Formula
  desc "Friendly and fast tool for sending HTTP requests"
  homepage "https://github.com/ducaale/xh"
  url "https://github.com/ducaale/xh/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "6ea21c669e891fa6bcc8c8bdcf9f13db32c44bc1cdafd052d1ec34610db9a004"
  license "MIT"
  head "https://github.com/ducaale/xh.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3ee63b3e89e43a5505b530030d8264e14c278947c4ea1fbc07e85fd41a6a01d9"
    sha256 cellar: :any_skip_relocation, big_sur:       "27e791be2ffa36e4fcbafaa57579a31c469f86f59fdec262d64b14c42a98b78b"
    sha256 cellar: :any_skip_relocation, catalina:      "45b6fbb7b899868f1bf12d4845438af75ccb95a6ce1cd688b4a38a2e11b356c4"
    sha256 cellar: :any_skip_relocation, mojave:        "7a5b06033a747806813fa1a7c9cec9e3db560f9126cafcfe4189cea66d8cb457"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "846701388730c4be481f0e1b047a27761acd6127a2dcd999b5679b1ab485f59e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    bin.install_symlink bin/"xh" => "xhs"

    man1.install "doc/xh.1"
    bash_completion.install "completions/xh.bash"
    fish_completion.install "completions/xh.fish"
    zsh_completion.install "completions/_xh"
  end

  test do
    hash = JSON.parse(shell_output("#{bin}/xh -I -f POST https://httpbin.org/post foo=bar"))
    assert_equal hash["form"]["foo"], "bar"
  end
end

class Xh < Formula
  desc "Friendly and fast tool for sending HTTP requests"
  homepage "https://github.com/ducaale/xh"
  url "https://github.com/ducaale/xh/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "d3e46b6db5a131237d5f980ccaae6f04c5ba7b06922d97c7f98f36f03cf581fe"
  license "MIT"
  head "https://github.com/ducaale/xh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "26292428e0b0ba0727e38b9693782e0c1a7f795ffb43c58d1eada081ef0aea44"
    sha256 cellar: :any_skip_relocation, big_sur:       "daf8cdcc24b0ac8a3b25abb4f42871c7af52dd2690bdaf94576433fa78e998cf"
    sha256 cellar: :any_skip_relocation, catalina:      "ea2de87328ac70becf698b04ea9ea8c8d4f04434cae2c42444dedcd02858e90a"
    sha256 cellar: :any_skip_relocation, mojave:        "a3824630363bb66568441a1197133ae8b98534bf033fbbbf6851aa0176fb5e41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f90037394c877924369d65e167bdc1c22364928a57a02c81aaa488c08be17cc"
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

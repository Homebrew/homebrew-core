class Zellij < Formula
  desc "Pluggable terminal workspace, with terminal multiplexer as the base feature"
  homepage "https://zellij.dev"
  url "https://github.com/zellij-org/zellij/archive/v0.35.2.tar.gz"
  sha256 "8255a92e40892856bc7dd7114958b8525a88dedab159b588f9907e4d4a2f27e9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cb7a2f31c9a1e774e88a316fe1839394ea2bcb3ed9818f9659b7c6f4e53743af"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9f359b83df9d22f0f220270db7be2afd3c206804d2edaa03c5af2968d8eade05"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b11e27c9d58ef1e6095e7095bab567da594920c932f468bee6642bff1720ad9a"
    sha256 cellar: :any_skip_relocation, ventura:        "0239b91d63e7e02b9ed5922e38db86c995c2b7cecb479e67e0942dc8db1b7c72"
    sha256 cellar: :any_skip_relocation, monterey:       "bdcefcb28c7335e5469d6fd4a93e515b1481a3e6fa902ed00d338ac8ab1eb3ba"
    sha256 cellar: :any_skip_relocation, big_sur:        "65e50d0c3787859480e9e0b2bc2883973631ed44973141ceecae6c68bf5ba09f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49d3f13372b37766638f92b2727f2c98109c0938271cc0d5d8bee3ee51078791"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"zellij", "setup", "--generate-completion")
  end

  test do
    assert_match("keybinds", shell_output("#{bin}/zellij setup --dump-config"))
    assert_match("zellij #{version}", shell_output("#{bin}/zellij --version"))
  end
end

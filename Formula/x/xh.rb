class Xh < Formula
  desc "Friendly and fast tool for sending HTTP requests"
  homepage "https://github.com/ducaale/xh"
  url "https://github.com/ducaale/xh/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "c44ca41b52b5857895d0118b44075d94c3c4a98b025ed3433652519a1ff967a0"
  license "MIT"
  head "https://github.com/ducaale/xh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "874b8a3054dc0af63821d676379035b9fdecdebab6c6650c67cf90cc3ec469e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc3552dfffd775c1821615ea20cab5d802f524cda56852872b19aab4e5a8c39b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f76ff5506d9c5a652b3dd64d00a956f9925b6401df3bc1f2e4a5d2c79125dbd2"
    sha256 cellar: :any_skip_relocation, sonoma:        "e89c6f6a68e21ac5675b35c3188176e0db77ef9044a58b04c6f88bb4ecb4087e"
    sha256 cellar: :any_skip_relocation, ventura:       "5f7006289f281e2112c556bcda4ebda6adccfa4038c6554ec321ecade3ac8137"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85b176f4d16727845c1671d52655cf485335434260b9e054defcca4b156d99ca"
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

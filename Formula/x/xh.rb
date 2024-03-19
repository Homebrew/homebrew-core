class Xh < Formula
  desc "Friendly and fast tool for sending HTTP requests"
  homepage "https://github.com/ducaale/xh"
  url "https://github.com/ducaale/xh/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "7e6b91a46bbbfee3907bf06d224a2e66a92b8f3e3950de43de5f06ce3beaacec"
  license "MIT"
  head "https://github.com/ducaale/xh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9611df49e93f108493f2aca24a19d5b5c5357b6acc5bc8bb51f30618518be7c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3688db71dc5ef7f97b58fe7ab25482b1cc21c57da17b27d5bdf225c137e1f0f9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d03e54a4022c1d22d3559b2f953547af7544fda43f6c91475d28fc32e5ef647"
    sha256 cellar: :any_skip_relocation, sonoma:         "bf75a392f42f4cd251d807da262dfd93e7870dcd82dcb76fbc8322cc39161064"
    sha256 cellar: :any_skip_relocation, ventura:        "4b75106daf535ff91fd8426cd3140c1c560d535a36471a4fb9cb46aea5e119e4"
    sha256 cellar: :any_skip_relocation, monterey:       "f90c91f5508eb30d0edd95d46adc9425a4fbd7d793e1d019f975c6e42b8dc42e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79beda507556d86e3841cc0b7b8901dfb5aad9af2ae7384b1b118e03233eb8b5"
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

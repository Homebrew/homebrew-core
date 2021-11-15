class Xh < Formula
  desc "Friendly and fast tool for sending HTTP requests"
  homepage "https://github.com/ducaale/xh"
  url "https://github.com/ducaale/xh/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "6abc32e2fa49a3c7a08379dbe7375735ec7bc8f25c3f29774e275e9dcac42711"
  license "MIT"
  head "https://github.com/ducaale/xh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd2689d384ddfa20e08580df6aac5c74d45fd0eafa9b190329c059feded8a32d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ef96333d23bd72060dc5864a6a92403a58adff6706aa522a01512eb4d1d7f3d5"
    sha256 cellar: :any_skip_relocation, monterey:       "4c09d8acf81dd65cdb77e2ca91eb9192087a061fdfe3a409932944a8843b3210"
    sha256 cellar: :any_skip_relocation, big_sur:        "664ec489f722f0b5c937e339ac091a8bca030eb7305914342a0d615c2d9fbab0"
    sha256 cellar: :any_skip_relocation, catalina:       "747f138fbe79a82aec78ad36bb55a05b196423696d5d31e3bd658ef0aa137a8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9702ce14bbeb1dd0a195b194997aae441ecbf4bc1916e829358a0aaa666fc36"
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

class Teip < Formula
  desc 'Masking tape to help commands "do one thing well"'
  homepage "https://github.com/greymd/teip"
  url "https://github.com/greymd/teip/archive/v2.3.0.tar.gz"
  sha256 "4c39466613f39d27fa22ae2a6309ac732ea94fdbc8711ecd4149fc1ecdfbaedf"
  license "MIT"
  head "https://github.com/greymd/teip.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "76306929a61d06bed2d50e7104f81fd38be5a4256f25b7c5bd4f59df0fc721e7"
    sha256 cellar: :any,                 arm64_monterey: "862454d4a7446db7996612e4ff3593e1861e8d2851be1c5d57afcde2ca79e229"
    sha256 cellar: :any,                 arm64_big_sur:  "847c470c7cef50c85c278209412a2bb1694527e0a44011e891ba37401a62ea9e"
    sha256 cellar: :any,                 ventura:        "c412035b3c7484fd79ca768dd7102d805af464ba0c46774a497544b58ae5baf2"
    sha256 cellar: :any,                 monterey:       "a3ae1dbbd8a3c7d8f0ea1e5713ce669b7184dfa375ee2466923baccb44882138"
    sha256 cellar: :any,                 big_sur:        "58d3e48e0feb2b60cf56f522ac1517dc3952f505298a30159211874f431bef62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "009824a80a45f6f54c8b70bd337358dfdcc636e86651e76a546c873bfbfaa25a"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "oniguruma"
  uses_from_macos "llvm" => :build # for libclang

  def install
    ENV["RUSTONIG_DYNAMIC_LIBONIG"] = "1"
    ENV["RUSTONIG_SYSTEM_LIBONIG"] = "1"
    system "cargo", "install", "--features", "oniguruma", *std_cargo_args
    man1.install "man/teip.1"
    zsh_completion.install "completion/zsh/_teip"
    fish_completion.install "completion/fish/teip.fish"
    bash_completion.install "completion/bash/teip"
  end

  test do
    ENV["TEIP_HIGHLIGHT"] = "<{}>"
    assert_match "<1>23", pipe_output("#{bin}/teip -c 1", "123", 0)
  end
end

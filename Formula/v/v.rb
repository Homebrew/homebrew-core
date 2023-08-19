class V < Formula
  desc "Z for vim"
  homepage "https://github.com/rupa/v"
  url "https://github.com/rupa/v/archive/v1.1.tar.gz"
  sha256 "6483ef1248dcbc6f360b0cdeb9f9c11879815bd18b0c4f053a18ddd56a69b81f"
  revision 1
  head "https://github.com/rupa/v.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f49df5380a45622ece889c919db67c7255d32e762452f0fa9788cd31c1748f68"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f49df5380a45622ece889c919db67c7255d32e762452f0fa9788cd31c1748f68"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f49df5380a45622ece889c919db67c7255d32e762452f0fa9788cd31c1748f68"
    sha256 cellar: :any_skip_relocation, ventura:        "18192fa0168a1a7750f041306e4b308bd0dc36373c8dc8faac7e54e94cfbdd81"
    sha256 cellar: :any_skip_relocation, monterey:       "18192fa0168a1a7750f041306e4b308bd0dc36373c8dc8faac7e54e94cfbdd81"
    sha256 cellar: :any_skip_relocation, big_sur:        "18192fa0168a1a7750f041306e4b308bd0dc36373c8dc8faac7e54e94cfbdd81"
    sha256 cellar: :any_skip_relocation, catalina:       "18192fa0168a1a7750f041306e4b308bd0dc36373c8dc8faac7e54e94cfbdd81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f49df5380a45622ece889c919db67c7255d32e762452f0fa9788cd31c1748f68"
  end

  uses_from_macos "vim"

  def install
    bin.install "v"
    man1.install "v.1"
  end

  test do
    (testpath/".vimrc").write "set viminfo='25,\"50,n#{testpath}/.viminfo"
    system "vim", "-u", testpath/".vimrc", "+wq", "test.txt"
    assert_equal "#{testpath}/test.txt", shell_output("#{bin}/v -a --debug").chomp
  end
end

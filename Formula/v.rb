class V < Formula
  desc "Z for vim"
  homepage "https://github.com/rupa/v"
  url "https://github.com/rupa/v/archive/v1.1.tar.gz"
  sha256 "6483ef1248dcbc6f360b0cdeb9f9c11879815bd18b0c4f053a18ddd56a69b81f"
  head "https://github.com/rupa/v.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a2d9792d879bcd5e4e5cee15b7ec2169062479a5fb30567506a54907c7e9eb2d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3fc81e5ce826641b151e30b303496e791296a2864ded5756d6bf47408aadec12"
    sha256 cellar: :any_skip_relocation, monterey:       "191fe2ee11c8e224bddfde66f4517d0fa43bc393ca852f2843a58e1174c259e7"
    sha256 cellar: :any_skip_relocation, big_sur:        "bbee3c584bca388ac94dcd3dc701c395fc4f44418dcd0f213033cec8f4f41b17"
    sha256 cellar: :any_skip_relocation, catalina:       "bbee3c584bca388ac94dcd3dc701c395fc4f44418dcd0f213033cec8f4f41b17"
    sha256 cellar: :any_skip_relocation, mojave:         "bbee3c584bca388ac94dcd3dc701c395fc4f44418dcd0f213033cec8f4f41b17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18eed94d7a0d343a527a6a77355a0e46106b79710a29c3faf835a8acf6fe777e"
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

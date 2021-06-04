class V < Formula
  desc "Z for vim"
  homepage "https://github.com/rupa/v"
  url "https://github.com/rupa/v/archive/v1.1.tar.gz"
  sha256 "6483ef1248dcbc6f360b0cdeb9f9c11879815bd18b0c4f053a18ddd56a69b81f"
  head "https://github.com/rupa/v.git"

  bottle :unneeded

  def install
    bin.install "v"
    man1.install "v.1"
  end

  test do
    (testpath/".vimrc").write "set viminfo='25,\"50,n#{testpath}/.viminfo"
    system "/usr/bin/vim", "-u", testpath/".vimrc", "+wq", "test.txt"
    assert_equal "#{testpath}/test.txt", shell_output("#{bin}/v -a --debug").chomp
  end
end

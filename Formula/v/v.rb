class V < Formula
  desc "Z for vim"
  homepage "https://github.com/rupa/v"
  license "WTFPL"
  revision 1
  head "https://github.com/rupa/v.git", branch: "master"

  stable do
    url "https://github.com/rupa/v/archive/refs/tags/v1.1.tar.gz"
    sha256 "6483ef1248dcbc6f360b0cdeb9f9c11879815bd18b0c4f053a18ddd56a69b81f"

    # Include license
    patch do
      url "https://github.com/rupa/v/commit/d19e6ea79fe361c2c62fbf514d52691042ff83e1.patch?full_index=1"
      sha256 "13ca8ba595db0b168fc0a8b8363386ecdbc216cc3d6a94811b5bfa30d5abbbbf"
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "02186023120c9b712a9eb310bf10b090cee1e693c8e4f302880a414d8ea6f3e7"
  end

  uses_from_macos "vim"

  conflicts_with "vlang", because: "both install `v` binaries"

  def install
    # Align documentation to generate `:all` bottle
    inreplace ["README", "v.1"], "/usr/local", HOMEBREW_PREFIX

    bin.install "v"
    man1.install "v.1"
  end

  test do
    (testpath/".vimrc").write "set viminfo='25,\"50,n#{testpath}/.viminfo"
    system "vim", "-u", testpath/".vimrc", "+wq", "test.txt"
    assert_equal "#{testpath}/test.txt", shell_output("#{bin}/v -a --debug").chomp
  end
end

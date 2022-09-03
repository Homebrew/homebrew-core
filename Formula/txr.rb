class Txr < Formula
  desc "Lisp-like programming language for convenient data munging"
  homepage "https://www.nongnu.org/txr/"
  url "http://www.kylheku.com/cgit/txr/snapshot/txr-281.tar.bz2"
  sha256 "a251c7c05f6e598a01e6130293c8e960f047277e87c6c1d7d8ce520c5ea5e2b3"
  license "BSD-2-Clause"

  livecheck do
    url "http://www.kylheku.com/cgit/txr"
    regex(/href=.*?txr[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f6200e6eee84022d6de21df3b7f37a6950ac703c042a4f52187dc422185875c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3d87c04cc49760cd85996ed4eff4b7f23e5f396b0ca0e87e02fc5d4474315ba3"
    sha256 cellar: :any_skip_relocation, monterey:       "768154426e58bbb4e5d510e7a8682f89e86a10ffd5b5107645c01548230b6baf"
    sha256 cellar: :any_skip_relocation, big_sur:        "b9a25b29efb07d0ee4657d3a03dc6284553b1a33cde9a9b217f52b3e5c5b17ce"
    sha256 cellar: :any_skip_relocation, catalina:       "eb695c1ac9bb884442ce8e42a902f7d7d6c0c518b6b95c132a3c049ac5f22d13"
  end

  depends_on "pkg-config" => :build
  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "libffi", since: :catalina

  def install
    system "./configure", "--prefix=#{prefix}", "--inline=static inline"
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "3", shell_output("#{bin}/txr -p '(+ 1 2)'").chomp
  end
end

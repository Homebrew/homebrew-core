class Txr < Formula
  desc "Lisp-like programming language for convenient data munging"
  homepage "https://www.nongnu.org/txr/"
  url "http://www.kylheku.com/cgit/txr/snapshot/txr-286.tar.bz2"
  sha256 "4aa64ef67ca17e00bd16d2fded275ae619a4771ef13b35148191e5ae97c4e47e"
  license "BSD-2-Clause"

  livecheck do
    url "http://www.kylheku.com/cgit/txr"
    regex(/href=.*?txr[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1aee5d40695669eb363fa7951b49bd1a56292a42647eae77b02786cb9bd6b9eb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5df97568e87dd134c57aa3bf00ff2dd762fc340e12ad70b7ef70e35f27e81288"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8343296e7d68dfe02ae5ecd5d971e0f1bea82dc9d6b51c80a75c680cacb487fe"
    sha256 cellar: :any_skip_relocation, ventura:        "45f13e3c271d48de5f02069821781ae48e5e181a1f3ba41c69f27e000af17016"
    sha256 cellar: :any_skip_relocation, monterey:       "db8063707149f15671cc1e67c29d1714d49de1276b28aa0dc25de1351e46c827"
    sha256 cellar: :any_skip_relocation, big_sur:        "c0c4ee550980e3a69c9e79526674520a02da21217dc3834ab960a940f32fd766"
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

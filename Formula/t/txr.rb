class Txr < Formula
  desc "Lisp-like programming language for convenient data munging"
  homepage "https://www.nongnu.org/txr/"
  url "http://www.kylheku.com/cgit/txr/snapshot/txr-294.tar.bz2"
  sha256 "41d90de05c286c644f40d4067070bad968b987042ab20c8ba3d7ad61811fa837"
  license "BSD-2-Clause"

  livecheck do
    url "http://www.kylheku.com/cgit/txr"
    regex(/href=.*?txr[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a386c9b7b8990ad4b1392f6bfda516fa6e962be3e423c10f8eb6e5bf67cef979"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce5e3fe77fd4bd609f55b6660bbd654fc72e8f2737bd70801046287a2be274de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "020ca0cc5f0f4cade6e67901bc61c59f5f56dc2fbe431b7e0570008d9084ee76"
    sha256 cellar: :any_skip_relocation, sonoma:         "227b71629d11ca67ccd8f63a7bc8f02afc07fbea8bd70418e9bdcc995a4a2380"
    sha256 cellar: :any_skip_relocation, ventura:        "8e18dd1ec9cc3d66bf93828f23cfd38b55eca6fc0e4855a2218d742625c2bf2d"
    sha256 cellar: :any_skip_relocation, monterey:       "35086d804ce8374de00e6c428fd90ad2e5df4f64ad92b07471e5a4532a4a324c"
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

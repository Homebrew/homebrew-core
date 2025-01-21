class Txr < Formula
  desc "Lisp-like programming language for convenient data munging"
  homepage "https://www.nongnu.org/txr/"
  url "https://www.kylheku.com/cgit/txr/snapshot/txr-298.tar.bz2"
  sha256 "49c0f101f3ee549159c3bd90ee0c434ce1c573e4fe23ed764f82e73075a31023"
  license "BSD-2-Clause"

  livecheck do
    url "https://www.kylheku.com/cgit/txr"
    regex(/href=.*?txr[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7b49ab72db9b399b3d6d8437c95b553de556e4cf8a61130cdd4fe3bcb9c6dee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "baf549a0faf46038e465cc2c5bdf9f6e5ef153b2927e179ef62ff5cb367e2ff7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "92c014b70e7e8aa2e3468ff752eefdb2d72160937418e6232e4437961496be5e"
    sha256 cellar: :any_skip_relocation, sonoma:        "3716e7e496bcd1c66aa69d33f7c378a6e3f3fd67fb088625822ff711be8a8889"
    sha256 cellar: :any_skip_relocation, ventura:       "9901204cb16d21e550d015e85696cba81e34c5bd2a530c8599c5ef6a2a3bea4e"
  end

  depends_on "pkgconf" => :build

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

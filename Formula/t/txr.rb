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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4d16c9b281fd0a8dd0e1a6df69cf0b3f0841a84c412ab655cd5bdd9901c3258c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8ce96dafb8b645acdc75f85061165b1612e3d5f9403282f36add248cbde64114"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46d3059fe1f8ef9dcdd08a15382e8811b3f7d5adf706cb6d89fe5e44b1795780"
    sha256 cellar: :any_skip_relocation, sonoma:         "cbce1537e3a3a1e45a20d7653026fbcc3712cfecc52cc81c9510ebe25f483f31"
    sha256 cellar: :any_skip_relocation, ventura:        "a0bc991eba0c07a931b58ed87390c8d20462069bf24da6c6f50dda6a84e508c9"
    sha256 cellar: :any_skip_relocation, monterey:       "dde261a2a8c52c180d91b270aeea3f845c5e2d82a36c670d9b66640e8ab21423"
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

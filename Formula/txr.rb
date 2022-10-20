class Txr < Formula
  desc "Lisp-like programming language for convenient data munging"
  homepage "https://www.nongnu.org/txr/"
  url "http://www.kylheku.com/cgit/txr/snapshot/txr-283.tar.bz2"
  sha256 "d939f0c47022896132b47a4a5eb13043e6a3ab5f5fd25bfbb2cf38da490fb386"
  license "BSD-2-Clause"

  livecheck do
    url "http://www.kylheku.com/cgit/txr"
    regex(/href=.*?txr[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3c1d1f48d9017608baf956dbb1d7446eeb63ac911e2a55927d42f5d438e2371"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "074a4eaaad8ae9f11c39559b8648609be55b3df0ffa497e3f5e8415e2612df4f"
    sha256 cellar: :any_skip_relocation, monterey:       "19d5c749db72c0559f87c92bfd80556e0f9558f5766ee15a976610f32a2611f1"
    sha256 cellar: :any_skip_relocation, big_sur:        "a995db4ad4176cd5a340757f4b7547a467e6932c7982fc52772e0ecfeba4345e"
    sha256 cellar: :any_skip_relocation, catalina:       "e795e315c105e5dded79be2a8f1693c5869639273a6e83f1300b01dcb53c6474"
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

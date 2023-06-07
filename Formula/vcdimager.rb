class Vcdimager < Formula
  desc "(Super) video CD authoring solution"
  homepage "https://www.gnu.org/software/vcdimager/"
  url "https://ftp.gnu.org/gnu/vcdimager/vcdimager-2.0.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/vcdimager/vcdimager-2.0.1.tar.gz"
  sha256 "67515fefb9829d054beae40f3e840309be60cda7d68753cafdd526727758f67a"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1468d801a2ebe345de5a8f0705aa9aed25dba7e667d050fefdaf860bb7bc1bd5"
    sha256 cellar: :any,                 arm64_monterey: "1b7326b090a4da9db5da22bc68ddbbb5f2544fb4a9070d3d4bfbb56a8b6e8d67"
    sha256 cellar: :any,                 arm64_big_sur:  "858d5a11fe090476123893d28b270ca807936569ed83b7b3808b79c9519fa99c"
    sha256 cellar: :any,                 ventura:        "4ba17eb68392d4d74137ec7dc693e044456749d71ae70016fc128680c6facd0f"
    sha256 cellar: :any,                 monterey:       "4740dd40f4e93c75d5876da5079e13c162dd5053485b900e51024cdd2c99fa4d"
    sha256 cellar: :any,                 big_sur:        "1cee3cb2e9d1bff3441733dce927dcff82b125d414c6c226095d0c334fe2b112"
    sha256 cellar: :any,                 catalina:       "cc883a163479f28c7303fcd378eba5461fabeafa5970bbb55695fb097cc2f3e0"
    sha256 cellar: :any,                 mojave:         "cb45bd1a48e551a60e8b344668a79e24414012ebc76a141ee6c0677ec21ad594"
    sha256 cellar: :any,                 high_sierra:    "993b40efcd1af1844ed14064de2551cecbdacc3a1c4d39f9fe1d8b289b3b6eb9"
    sha256 cellar: :any,                 sierra:         "2e8567e154610bb1c3c29a50c6fc9f150ddf84c36d6c94fc35a1f8ab3a495f13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb6dace78a99bd83f85d18ebc1630cdd0dc81be0cc6a630661d4d8fb2cfe64ee"
  end

  depends_on "pkg-config" => :build
  depends_on "libcdio"
  depends_on "popt"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"vcdimager", "--help"
  end
end

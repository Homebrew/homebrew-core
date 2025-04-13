class Txr < Formula
  desc "Lisp-like programming language for convenient data munging"
  homepage "https://www.nongnu.org/txr/"
  url "https://www.kylheku.com/cgit/txr/snapshot/txr-299.tar.bz2"
  sha256 "9da0e12f6b6db9c4262e92214863c90f89cd40e4fa8b5eac2b983bf65194112a"
  license "BSD-2-Clause"

  livecheck do
    url "https://www.kylheku.com/cgit/txr"
    regex(/href=.*?txr[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f992cbed8d7a0036837f0ffd69a346a859d982810e5f01af1597dd8ae8160578"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43f055721c56bd67fa9587f1d6215962fae46aa8613cbb5f6c8a4409a55ca06d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6de5f5a5bf6d757fba045f6c3c2a03f63662d5909ed6467b9bf4e07c2fe01e4c"
    sha256 cellar: :any_skip_relocation, sonoma:        "adc193c9171eb012618c4a990020428c5b8c8f481a7a91b415a1764d1d00d111"
    sha256 cellar: :any_skip_relocation, ventura:       "c071be5370824ec8c3225aaf1d7d8dc74919cf8669c48598184a8c2b0fa2d581"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91ddc85af12c95ff8070bd5359ef3e2451930ec9788304264be9bb1f9c458589"
  end

  depends_on "pkgconf" => :build

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "libffi", since: :catalina
  uses_from_macos "libxcrypt"
  uses_from_macos "zlib"

  on_linux do
    depends_on "gcc" => :build
  end

  fails_with :gcc do
    version "11"
    cause "Segmentation faults running TXR"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "tests" # run tests as upstream has gotten reports of broken TXR in Homebrew
    system "make", "install"
    (share/"vim/vimfiles/syntax").install Dir["*.vim"]
  end

  test do
    assert_equal "3", shell_output("#{bin}/txr -p '(+ 1 2)'").chomp
  end
end

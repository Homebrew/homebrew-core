class Txr < Formula
  desc "Lisp-like programming language for convenient data munging"
  homepage "https://www.nongnu.org/txr/"
  url "https://www.kylheku.com/cgit/txr/snapshot/txr-302.tar.bz2"
  sha256 "f0de012ed62218e049d09a39ae6a9387598d8eac12a7c2d7d9d906c27c36ef54"
  license "BSD-2-Clause"

  livecheck do
    url "https://www.kylheku.com/cgit/txr"
    regex(/href=.*?txr[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0feab2e83756d3361b3aa05cd98fcbcb4e9fe346f5796a9020f971c8aa2a284c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3190a9ee3e9cad9ea15afb5e5950fd15b2547ad06fd78c9dfc972439628cfb11"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f470ff3b63fc4ca54e373852496d845bd64150a2b092702f1f33cbf7ab257bb1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d10ef0d21324ea961c822c61ff44de39177b401c70f08bb89b5e4473df3b6f97"
    sha256 cellar: :any_skip_relocation, sonoma:        "275b1b90e5d210cbcbf43ca06fb42f7ee4b881af984b554237b959e37d1203bc"
    sha256 cellar: :any_skip_relocation, ventura:       "c576ede754b86b6672d3e96e16a204eb9b6173ac30438dfff9d179340bef5aa6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d10f50542ed10a224eb99faddb04ba00250aa2509788b893512b6c7f70a0a759"
  end

  depends_on "pkgconf" => :build

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "libffi", since: :catalina
  uses_from_macos "libxcrypt"
  uses_from_macos "zlib"

  def install
    # FIXME: We need to bypass the compiler shim to work around `-mbranch-protection=standard`
    # (specifically pac-ret) causing tests/012/compile.tl to fail with an illegal instruction
    if OS.linux? && Hardware::CPU.arch == :arm64
      ENV["CC"] = DevelopmentTools.locate(ENV.cc)
      ENV.append_to_cflags ENV["HOMEBREW_OPTFLAGS"] if ENV["HOMEBREW_OPTFLAGS"]
      ENV.append "CPPFLAGS", "-mbranch-protection=bti"
    end

    # FIXME: Workaround to avoid the compiler shim suppressing warnings needed during configure.
    # Existing shim logic only works for autotools configure scripts where `as_nl` is used.
    with_env(as_nl: "\n") do
      system "./configure", "--no-debug-flags", "--prefix=#{prefix}"
    end
    system "make", "VERBOSE=1"
    system "make", "tests" # run tests as upstream has gotten reports of broken TXR in Homebrew
    system "make", "install"
    (share/"vim/vimfiles/syntax").install Dir["*.vim"]
    Utils::Gzip.compress(*man1.glob("*.1"))
  end

  test do
    assert_equal "3", shell_output("#{bin}/txr -p '(+ 1 2)'").chomp
  end
end

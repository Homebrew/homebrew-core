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
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5a3e2696544766b198f2d6be38cee732e7757bc465a85951d3cc69c589a74490"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "080e9b53e0bf6f5fdf978e4498dce5138f32750ceaeeda57a4343a9fc3d9ca79"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7c6793df7533f54d70fb81522f014fa532c20ddb4386557d40554146b0aa53b"
    sha256 cellar: :any_skip_relocation, sonoma:        "0db191f5177f88c2347a3374bd99847bc65034f200bd83ed891de7cb69d56823"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef7c5786a174ca30e31d3d87afa2aeb796cab3c72a837f01397af9011cfe9885"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28c0d4e14ed8bf41888293d49df188ed82b731ef0dd5fe30fe279c69f4a17b1f"
  end

  depends_on "pkgconf" => :build

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "libffi"
  uses_from_macos "libxcrypt"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # FIXME: We need to bypass the compiler shim to work around `-mbranch-protection=standard`
    # (specifically pac-ret) causing tests/012/compile.tl to fail with an illegal instruction
    if OS.linux? && Hardware::CPU.arm64?
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

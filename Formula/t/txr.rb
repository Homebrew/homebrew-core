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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8641468e2c261437ffcc3f0c9625a8f1f839f995c7ed7b452684db37bd3a24d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5011b7cb0fcfeae6fd9ad108ff54d0662a55db8478002b0ab333a74ea36e7222"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8c9a0c0475cda5d4c108ff27f40e87150656795008ea14ad7657076421fdaf4"
    sha256 cellar: :any_skip_relocation, sonoma:        "5dc1e4925fd0d626bdf266f85a3fd44c30845db68915acefb6d16ccb55926723"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "43cd336b765f13dea501739ea53c0c6354301433645fb8da16c8d51217d8170d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f836edb00ae58379e6ff4153e6a84ab60fa1fdb97f0c6ae9121ddacde2b526be"
  end

  depends_on "pkgconf" => :build

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "libffi"
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

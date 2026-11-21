class Txr < Formula
  desc "Lisp-like programming language for convenient data munging"
  homepage "https://www.nongnu.org/txr/"
  url "https://www.kylheku.com/cgit/txr/snapshot/txr-303.tar.bz2"
  sha256 "b985117b7e55b98f1cd6952d749542e8f1e6c23c7c107fea64ade27f59bd0ae5"
  license "BSD-2-Clause"

  livecheck do
    url "https://www.kylheku.com/cgit/txr"
    regex(/href=.*?txr[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    manifest_sha256 "65705350c77a276d7e4b8db81999c1bd6ec4c57a6ae62870ceb74ac524e09162"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "000af3c53e57c5fdcea54f1b32f703fa2635bf3ddebb5813ddad576461215f48"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0f8eee549e90b640a695babe0a710b76203941bd942ac5ef5bfb3f1465731198"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0c982025f8b78726aace6f9b14439841b6e31a2a4037664b7072c97b6990d6c4"
    sha256 cellar: :any,                 arm64_linux:       "6ee2267ba6bb7f8b387fe1540bb8f71f45433a773dcea88f0339a1010c4fce12"
    sha256 cellar: :any,                 x86_64_linux:      "092220daea4b5a7249047aa2eff7962416c603c9255a3dea5e21b975db6a107c"
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

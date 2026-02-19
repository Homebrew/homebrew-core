class Termrec < Formula
  desc "Record videos of terminal output"
  homepage "https://angband.pl/termrec.html"
  url "https://github.com/kilobyte/termrec/archive/refs/tags/v0.19.tar.gz"
  sha256 "0550c12266ac524a8afb764890c420c917270b0a876013592f608ed786ca91dc"
  license "LGPL-3.0-or-later"
  head "https://github.com/kilobyte/termrec.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "83130b80ca5853bcb36c51451cf600c22c5fa8138cd525723cd8e9b960ff9791"
    sha256 cellar: :any,                 arm64_sequoia: "9a3d784e024e949a5fe44cb29e1edfbe6021bc07f9aba114337c49aa9e94f755"
    sha256 cellar: :any,                 arm64_sonoma:  "3967ae0f38e3f4232a886c6b96d51db474588e950dcc3c3acf6c4b2b02425a1a"
    sha256 cellar: :any,                 sonoma:        "6b37974b1c45960c3572d2a030dc45a1c3d10e4e8165e158167a5949625e1f72"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "adc70be44639d06db0b15cbd211ded8e4e84826389152de96dc9e089a9d78a0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd26bd9def49e75e6030be96b864fa6cb0ddca5660f06b858d9176edecf6883b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "xz"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Work around build error: call to undeclared function 'forkpty'
    # Issue ref: https://github.com/kilobyte/termrec/issues/8
    ENV.append "CFLAGS", "-include util.h" if DevelopmentTools.clang_build_version >= 1403

    system "./autogen.sh"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"termrec", "--help"
  end
end

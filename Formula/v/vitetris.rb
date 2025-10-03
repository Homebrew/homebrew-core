class Vitetris < Formula
  desc "Terminal-based Tetris clone"
  homepage "https://www.victornils.net/tetris/"
  url "https://github.com/vicgeralds/vitetris/archive/refs/tags/v0.59.1.tar.gz"
  sha256 "699443df03c8d4bf2051838c1015da72039bbbdd0ab0eede891c59c840bdf58d"
  license "BSD-2-Clause"
  head "https://github.com/vicgeralds/vitetris.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "ab9a0fde775af14600b636a041e026c987933c871cec3e67a4184f6521a61b2e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "dd6ea28531dfab3328f90186dc273aec6bc0fe8aea3975c464fc69f780566547"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3e97501d1c6455a0f05c42b8ac32a26a11361329c13f031c29be0302303c3f8c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a7e9d7a5f17a0ecec24844b5170fa3a022e98e957bc8c957aed74278f90b5e6f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1abdb3a699387c63bb17e24037ba5f6233758ba792964c076db235622de37c0c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4ab846d19502cc5c5aea07435f491a2e7e73f84b37bae0d40e79dffed69a8e6b"
    sha256 cellar: :any_skip_relocation, sonoma:         "7cc3b8950c3b0b366c192dadad3b3ab1293322a1db723144168c0122e2681986"
    sha256 cellar: :any_skip_relocation, ventura:        "ffb6b3d04c4295734d3278c42f819ff40a9b17e4b01869cb9c8fdadba2e8657f"
    sha256 cellar: :any_skip_relocation, monterey:       "8430ca0038c16d9e4b3e65d2ff25ed6b97bde494b28d06d55386dd01288de711"
    sha256 cellar: :any_skip_relocation, big_sur:        "1fa572cc6545ae0b7dffcabbab5d15f256c29d0a7d8f8af1bfef4371bf31401c"
    sha256 cellar: :any_skip_relocation, catalina:       "9b92a065c5c65480ac9fbe8b3414e3c8c467ba6decbe72054a269f18b77e4280"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "2b8820b3b339b4694117c0598599f072ed88a046ccb8941f6cb437895a1042da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8081c35e8f308bd3c0bd5521edce69ed47a4af99700a9799ebffe8e52430989"
  end

  def install
    # workaround for newer clang
    ENV.append_to_cflags "-Wno-implicit-int" if DevelopmentTools.clang_build_version >= 1403

    # remove a 'strip' option not supported on OS X and root options for
    # 'install'
    inreplace "Makefile", "-strip --strip-all $(PROGNAME)", "-strip $(PROGNAME)"

    system "./configure", "--prefix=#{prefix}", "--without-xlib"
    system "make", "install"
  end

  test do
    system bin/"tetris", "-hiscore"
  end
end

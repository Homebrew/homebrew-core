class WrenCli < Formula
  desc "Simple REPL and CLI tool for running Wren scripts"
  homepage "https://github.com/wren-lang/wren-cli"
  url "https://github.com/wren-lang/wren-cli/archive/refs/tags/0.4.0.tar.gz"
  sha256 "fafdc5d6615114d40de3956cd3a255e8737dadf8bd758b48bac00db61563cb4c"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "94398558d4e785bfeaf83be6aeec15896129441f07d3226003521bf882a1a200"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "09debbe79f6af18ccbb0f2a4aabf117cfa7b3a33fb455fdd7b943ab8c8e399ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "228ccca95d81d073708b4b53278b5fa8a2d4a070c4a0c613cf3eb7181d26ba64"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8b957b7b11199a05f30c2b5fcaea97cdb2cc2ac212b3e6633e51e2f4b5820a53"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72841b4f7f8562ee72899224e0c1d04c72047be6f86ae00df7aed6c3370320e4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b2f527af8074dda364da8571385473dcaee9b3034d30cd1407ef6a4057e0e4a0"
    sha256 cellar: :any_skip_relocation, sonoma:         "26e8aa2bdb4bd752760649c2bdb0be3446a6ef032dde08e12be8be9148f0cdcc"
    sha256 cellar: :any_skip_relocation, ventura:        "2ed8a9779e0eb400fb4ae0c6aa4db564e0ba996b449b267ea054d8220438a756"
    sha256 cellar: :any_skip_relocation, monterey:       "c4abf9f5a795361333ee735c25c0c72754b69c974f1a910af64414ff7912f398"
    sha256 cellar: :any_skip_relocation, big_sur:        "1eb3fa798b1204360be58481e36921299678ac6da63ab4f30009b2f452fc6baa"
    sha256 cellar: :any_skip_relocation, catalina:       "726fa674e71292e1474d7f7d68b7b477f797112a1348cdb4a2240e5d48776a95"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "c0103413af78077f54ef210d0bb3ef707bfcc9301868252685ec6fb133087d36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2014cc9da16b381e355b12f19a020eaba1cc182c41f07fcb4a17dab5597f6a61"
  end

  # Backport fix for glibc >= 2.34
  patch do
    url "https://github.com/wren-lang/wren-cli/commit/18553636618a4d33f10af9b5ab92da6431784a8c.patch?full_index=1"
    sha256 "ee10f762901cecd897702aa5397868e880d64cfaded95ac76653ee1e01892eec"
  end

  def install
    if OS.mac?
      system "make", "-C", "projects/make.mac"
    else
      system "make", "-C", "projects/make"
    end
    bin.install "bin/wren_cli"
    pkgshare.install "example"
  end

  test do
    cp pkgshare/"example/hello.wren", testpath
    assert_equal "Hello, world!\n", shell_output("#{bin}/wren_cli hello.wren")
  end
end

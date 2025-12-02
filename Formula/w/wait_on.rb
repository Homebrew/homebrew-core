class WaitOn < Formula
  desc "Provides shell scripts with access to kqueue(3)"
  homepage "https://www.freshports.org/sysutils/wait_on/"
  url "https://pkg.freebsd.org/ports-distfiles/wait_on-1.1.tar.gz"
  mirror "https://mirrorservice.org/sites/distfiles.macports.org/wait_on/wait_on-1.1.tar.gz"
  sha256 "d7f40655f5c11e882890340826d1163050e2748de66b292c15b10d32feb6490f"
  license "BSD-4-Clause"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "e548523ed71f1fd1796069ae4182d5ae191eb7a76fc4ad83e39353c648b85e23"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "ffd8be74922f931670be9f5bb8fbea47735ddef928a74d44562bcf0e2969c01d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "866722ebcb399e5524776cc6ffdd2022112287368e4fa768b8b9bbfe2a8a30cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2d6736732caacfe89a285f06256c397fefb2e47f11032f282d84e874b384fd21"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d7664213ff9c0136cb6e8add7a2bfc87f2bf316594f9305e53a287834b12c72"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ca26e2aeef0c80f7b61b392ea50b03f7465bcdc0c8c3be2248aca538935fdc78"
    sha256 cellar: :any_skip_relocation, sonoma:         "272cd3ee9f3a5c193057d419fe9b4b5d787e6c0de452c1c20bdca85a56ba05b1"
    sha256 cellar: :any_skip_relocation, ventura:        "9427ad9d03fbceae7b129c5f00e7ad2fdd4e6d7630c933e1e1ef8554166cb1ed"
    sha256 cellar: :any_skip_relocation, monterey:       "abc2d21a1add07205d46997d869de4a896bd47174033c0e392e74c17813251b1"
    sha256 cellar: :any_skip_relocation, big_sur:        "b7a8f90a892e9b2cbe4455d9fd4aedfdf7b65c3534e00b8849e94652171bd4e3"
    sha256 cellar: :any_skip_relocation, catalina:       "befef0facd28d26c22ed14197e74c1bff41c9cd2f787ae4bee59027cfb89b2c7"
  end

  depends_on "bmake" => :build
  depends_on :macos # needs BSD kqueue

  def install
    system "bmake"
    system "bmake", "install", "MK_INSTALL_AS_USER=yes", "MANDIR=#{man}", "PREFIX=#{prefix}"
  end

  test do
    system bin/"wait_on", "-v"
  end
end

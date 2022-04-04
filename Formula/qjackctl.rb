class Qjackctl < Formula
  desc "Simple Qt application to control the JACK sound server daemon"
  homepage "https://qjackctl.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/qjackctl/qjackctl/0.9.7/qjackctl-0.9.7.tar.gz"
  sha256 "524843618152070c90a40a18d0e9a16e784424ce54231aff5c0ced12f2769080"
  license "GPL-2.0-or-later"
  head "https://git.code.sf.net/p/qjackctl/code.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{url=.*?/qjackctl[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_monterey: "dd6daea0d11b6c62f41505f22fe826c7d46937268dff2f185d3d853ee1890a8e"
    sha256 arm64_big_sur:  "855c74c10b3ab077e0951da608b86676b382478deb722069f1150241a9f7dc94"
    sha256 monterey:       "04e9744e207ad9fe2606ade63c5a29ac409272c16a94f2da27485d213bcfbda3"
    sha256 big_sur:        "32d70991bbeddfe94caf896714e472465c4ace052e83853351dceb8256a92641"
    sha256 catalina:       "342d2cff1bad3ab3424bb7bbc8b6e4844313d3c9f2de6112a0dcdcde226ea8f1"
  end

  depends_on "cmake" => :build
  depends_on "jack"
  depends_on "qt"

  def install
    args = std_cmake_args + %w[
      -DCONFIG_DBUS=OFF
      -DCONFIG_PORTAUDIO=OFF
      -DCONFIG_XUNIQUE=OFF
    ]

    system "cmake", *args
    system "cmake", "--build", "."
    system "cmake", "--install", "."

    prefix.install bin/"qjackctl.app"
    bin.install_symlink prefix/"qjackctl.app/Contents/MacOS/qjackctl"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/qjackctl --version 2>&1")
  end
end

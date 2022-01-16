class Qjackctl < Formula
  desc "Simple Qt application to control the JACK sound server daemon"
  homepage "https://qjackctl.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/qjackctl/qjackctl/0.9.6/qjackctl-0.9.6.tar.gz"
  sha256 "39ca2b9d83acfdd16a4c9b3eccd80e1483e1f9a446626f5d00ac297e6f8a166b"
  license "GPL-2.0-or-later"
  head "https://git.code.sf.net/p/qjackctl/code.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{url=.*?/qjackctl[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_monterey: "1b46db8481b0aec95ed530f94dda8f984aaf81ff99d5b968a4e030bcc711a51e"
    sha256 arm64_big_sur:  "1b46db8481b0aec95ed530f94dda8f984aaf81ff99d5b968a4e030bcc711a51e"
    sha256 big_sur:        "d8f854c69cbedb599a259ce77293e8bbb287ac2e3885c1ce4962be12aa49c6d9"
    sha256 catalina:       "f6ed6c17172898b5b6899835a1fabf88e2f667602efa9741c3ad9558ce179aba"
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
    assert_match version.to_s, shell_output("#{bin}/qjackctl --version 2>&1", 1)
  end
end

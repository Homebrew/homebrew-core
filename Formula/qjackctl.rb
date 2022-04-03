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
    sha256 cellar: :any, arm64_monterey: "1b144f9e426d110c45baf9947c91d772a6b009ce7782caafc0b534e22873cd05"
    sha256 cellar: :any, arm64_big_sur:  "2ab81b4a160c701801c3fb1fb825f25604b6033be11b47e5e1780f4301d7d7a0"
    sha256 cellar: :any, monterey:       "563f4b996a365640d37b858a47d7db2b958f5caae9fab93aedfdaaa980140153"
    sha256 cellar: :any, big_sur:        "a66f26c99a0f9ee7a7b8c7c935a54aa6280e35363b9f7ba0b3a935743366c7fa"
    sha256 cellar: :any, catalina:       "2a245cbda6afc11f608f59149efa21219b40f3e77711e39032ba94c92ff3e439"
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

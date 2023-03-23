class Qjackctl < Formula
  desc "Simple Qt application to control the JACK sound server daemon"
  homepage "https://qjackctl.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/qjackctl/qjackctl/0.9.10/qjackctl-0.9.10.tar.gz"
  sha256 "9c07a8a98744b42c53a93864e47842d818dfaaea85078356851c6592997f1eee"
  license "GPL-2.0-or-later"
  head "https://git.code.sf.net/p/qjackctl/code.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{url=.*?/qjackctl[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_ventura:  "969d62e274f7b4dfb9dd10e752e69e9b109b947b7673d13d62c5dc2978059c8d"
    sha256 arm64_monterey: "10966c283775575130aa0cbe9bfde61936e96e4f1651e8bbe78c360d36883644"
    sha256 arm64_big_sur:  "723887155a39164ee86b0e3c27bf4593dd1707c132acfb4aff5377e3605e8f80"
    sha256 ventura:        "0b70b75f53ba9521034699ecc77ca32aca29c3f886b3168b312aa3b75790ff2c"
    sha256 monterey:       "8c4317142ad22188b9009671ad693e065ccdff265fd21ba6ecd5840ee705c2a9"
    sha256 big_sur:        "92a4a2d0b93703b0b1327d8fe4ce75d8cdfc4fd12656d1d8133f7317953656df"
    sha256 x86_64_linux:   "95e30dc63dff2c0fb29c4d5fe16f57baf812ef15f44485c08aaab3946245978f"
  end

  depends_on "cmake" => :build
  depends_on "jack"
  depends_on "qt"

  fails_with gcc: "5"

  def install
    args = std_cmake_args + %w[
      -DCONFIG_DBUS=OFF
      -DCONFIG_PORTAUDIO=OFF
      -DCONFIG_XUNIQUE=OFF
    ]

    system "cmake", *args
    system "cmake", "--build", "."
    system "cmake", "--install", "."

    if OS.mac?
      prefix.install bin/"qjackctl.app"
      bin.install_symlink prefix/"qjackctl.app/Contents/MacOS/qjackctl"
    end
  end

  test do
    # Set QT_QPA_PLATFORM to minimal to avoid error "qt.qpa.xcb: could not connect to display"
    ENV["QT_QPA_PLATFORM"] = "minimal" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match version.to_s, shell_output("#{bin}/qjackctl --version 2>&1")
  end
end

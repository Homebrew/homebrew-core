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
    rebuild 1
    sha256 arm64_monterey: "0f3e64ef2b94a5e8d58c837b6fcd60a788977ff00f847bd9e8379e7303308bb8"
    sha256 arm64_big_sur:  "e987344fe0fbd559ac3ece1aa750932051f87eb345242e37b202d95ea1fe8431"
    sha256 monterey:       "c06b8e8e299414b51a498812d61a5200e80903184eb01136acf7ee7eca7038b8"
    sha256 big_sur:        "87baabe3f3790a992f9309d9f877efd74dd76c3f03df7b6dead6199100141e90"
    sha256 catalina:       "b2ead9c2ef60464193f4d1b1d32454024d5f4fbd8c712d56c1cea2c2bb780340"
    sha256 x86_64_linux:   "18e9599c50eea0ed17ea7b01f1c0cc1bfadc04403e06b85f9d2a99d61be4d9ae"
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

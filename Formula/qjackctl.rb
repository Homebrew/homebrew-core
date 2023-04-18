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
    sha256 arm64_ventura:  "eb49970eb50d9bf6acee91686ff954a5ea359f54403648f7e36b28eca88627e8"
    sha256 arm64_monterey: "3d9cf7c86aebab0211ce33096f3ce58c9ca20dd64d807983af587985d67e654e"
    sha256 arm64_big_sur:  "fef6e82b598486397a37f47be14d59679edf640ce65e596cbf24ed4a9de012c1"
    sha256 ventura:        "94541708be29336499fd3c6c31aab958e0bbbc08a572813e9f097c818981763a"
    sha256 monterey:       "cd9e3f832de10909db46630e31feeff2d96052caa3184442b600ab3848c42721"
    sha256 big_sur:        "935ed93232348c3cc81a5b5e4df0ca19edc83c350a4c1d868abd7c91fc408369"
    sha256 x86_64_linux:   "9b72fcfd3df6c4cfb5c80f66046a720f9fc40f30995b34a92d1842a2fb357453"
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

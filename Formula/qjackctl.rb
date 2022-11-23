class Qjackctl < Formula
  desc "Simple Qt application to control the JACK sound server daemon"
  homepage "https://qjackctl.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/qjackctl/qjackctl/0.9.8/qjackctl-0.9.8.tar.gz"
  sha256 "07cd9f0a876ac7b73c3b6e4ec08aae48652a81a771f0cbbef267af755a7f7de7"
  license "GPL-2.0-or-later"
  head "https://git.code.sf.net/p/qjackctl/code.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{url=.*?/qjackctl[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_ventura:  "611ddb4bce1209b10b53dbc2e898be56c298ef4eb364c02ca3c4b86f97e4ccfa"
    sha256 arm64_monterey: "ae0dc29135764e483923c8b68ab2bc591e90dcf75e468bc46536871d561f58da"
    sha256 arm64_big_sur:  "269e87d8ad4089315682ae72712c5237894308262179420977b6f7ab1dafce56"
    sha256 ventura:        "1da8253aebc2b4e92e86e708573f4a9a373e398b902288597bf9d2ba573f4ead"
    sha256 monterey:       "1c10210499c4fdc95ec7c68c1faa8d58102015ee31122a2c5901c31b7250c020"
    sha256 big_sur:        "b0485a54fb9dcc3ffca4e775ea51af05772c929a62fbaae61df42774fe949e03"
    sha256 catalina:       "b0ac3dc4132c0c4c018256dde8a01ab7e61d56d635b9e1801264571b314e4a86"
    sha256 x86_64_linux:   "1ec75ff8b04ff01df9b479060dc69f8879282b1ecdb3e9ec1210fedccd840eae"
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

class Wxmaxima < Formula
  desc "Cross platform GUI for Maxima"
  homepage "https://wxmaxima-developers.github.io/wxmaxima/"
  url "https://github.com/wxMaxima-developers/wxmaxima/archive/refs/tags/Version-23.04.1.tar.gz"
  sha256 "869e20a02e0da97bd92da20e8a9b8a04facaea387feb09c16c5f23445b4e163f"
  license "GPL-2.0-or-later"
  head "https://github.com/wxMaxima-developers/wxmaxima.git", branch: "main"

  livecheck do
    url :stable
    regex(/^Version[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "01dc9ce1e4298c83b018f327f2dce8f706144d8ae0e38afa5b9457de247bdec0"
    sha256 arm64_monterey: "699cae9eda02efb7b714f53320a368ca0a5d82d02f20321dde020af059e67716"
    sha256 arm64_big_sur:  "b2514504bd74cf508ae162483f122f35da37d7e47cc8e41e139fb6c73e7d2d93"
    sha256 ventura:        "12aa5e57847bac51599e1e4d41971804bfac67fda4af027f50bbb5e9f1aba68f"
    sha256 monterey:       "9079d6d8a42483b2330b7617b2cdda35be15dfa18288482b59718dd3769c9286"
    sha256 big_sur:        "ad310c0fd8747e4ed8f771091e94aabf66e529fb9ec2f6fb4b0519078a3ce764"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "ninja" => :build
  depends_on "maxima"
  depends_on "wxwidgets"

  def install
    system "cmake", "-S", ".", "-B", "build-wxm", "-G", "Ninja", *std_cmake_args
    system "cmake", "--build", "build-wxm"
    system "cmake", "--install", "build-wxm"
    bash_completion.install "data/wxmaxima"

    return unless OS.mac?

    prefix.install "build-wxm/src/wxMaxima.app"
    bin.write_exec_script prefix/"wxMaxima.app/Contents/MacOS/wxmaxima"
  end

  def caveats
    <<~EOS
      When you start wxMaxima the first time, set the path to Maxima
      (e.g. #{HOMEBREW_PREFIX}/bin/maxima) in the Preferences.

      Enable gnuplot functionality by setting the following variables
      in ~/.maxima/maxima-init.mac:
        gnuplot_command:"#{HOMEBREW_PREFIX}/bin/gnuplot"$
        draw_command:"#{HOMEBREW_PREFIX}/bin/gnuplot"$
    EOS
  end

  test do
    # Error: Unable to initialize GTK+, is DISPLAY set properly
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match "algebra", shell_output("#{bin}/wxmaxima --help 2>&1")
  end
end

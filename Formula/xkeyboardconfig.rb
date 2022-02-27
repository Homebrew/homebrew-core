class Xkeyboardconfig < Formula
  desc "Keyboard configuration database for the X Window System"
  homepage "https://www.freedesktop.org/wiki/Software/XKeyboardConfig/"
  url "https://xorg.freedesktop.org/archive/individual/data/xkeyboard-config/xkeyboard-config-2.35.1.tar.xz"
  sha256 "18ce50ff0c74ae6093062bce1aeab3d363913ea35162fe271f8a0ce399de85cc"
  license "MIT"
  head "https://gitlab.freedesktop.org/xkeyboard-config/xkeyboard-config.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e38b424812f6c9a373e850a76fadb56e6fc9a0545885fa5ac5869f064c4decf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0e38b424812f6c9a373e850a76fadb56e6fc9a0545885fa5ac5869f064c4decf"
    sha256 cellar: :any_skip_relocation, monterey:       "0e38b424812f6c9a373e850a76fadb56e6fc9a0545885fa5ac5869f064c4decf"
    sha256 cellar: :any_skip_relocation, big_sur:        "0e38b424812f6c9a373e850a76fadb56e6fc9a0545885fa5ac5869f064c4decf"
    sha256 cellar: :any_skip_relocation, catalina:       "0e38b424812f6c9a373e850a76fadb56e6fc9a0545885fa5ac5869f064c4decf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28e78229dda1c08ec348dc229354d8039f7632dffa2603319a48942718984fe3"
  end

  depends_on "gettext" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "python@3.10" => :build

  uses_from_macos "libxslt" => :build

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    assert_predicate man7/"xkeyboard-config.7", :exist?
    assert_equal "#{share}/X11/xkb", shell_output("pkg-config --variable=xkb_base xkeyboard-config").chomp
    assert_match "Language-Team: English",
      shell_output("strings #{share}/locale/en_GB/LC_MESSAGES/xkeyboard-config.mo")
  end
end

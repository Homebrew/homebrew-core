class WaylandProtocols < Formula
  desc "Additional Wayland protocols"
  homepage "https://wayland.freedesktop.org"
  url "https://gitlab.freedesktop.org/wayland/wayland-protocols/-/releases/1.37/downloads/wayland-protocols-1.37.tar.xz"
  sha256 "a70e9be924f2e8688e6824dceaf6188faacd5ae218dfac8d0a3d0976211ef326"
  license "MIT"

  livecheck do
    url "https://wayland.freedesktop.org/releases.html"
    regex(/href=.*?wayland-protocols[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "54a22a7c7074b2100eb63e4949db7720214b523360b3de656153fc8af84810ee"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :test
  depends_on :linux

  def install
    system "meson", "setup", "build", "-Dtests=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system "pkg-config", "--exists", "wayland-protocols"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end

class WaylandProtocols < Formula
  desc "Additional Wayland protocols"
  homepage "https://wayland.freedesktop.org"
  url "https://wayland.freedesktop.org/releases/wayland-protocols-1.24.tar.xz"
  sha256 "bff0d8cffeeceb35159d6f4aa6bab18c807b80642c9d50f66cba52ecf7338bc2"
  license "MIT"

  livecheck do
    url "https://wayland.freedesktop.org/releases.html"
    regex(/href=.*?wayland-protocols[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "46ff9ea4c52643e3a0c7291e4dcf3badcb3adc64648e6c3e3c949fdca53b4f49"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "wayland" => :build
  depends_on :linux

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    system "pkg-config", "--exists", "wayland-protocols"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end

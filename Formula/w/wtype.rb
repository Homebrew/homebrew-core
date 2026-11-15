class Wtype < Formula
  desc "Xdotool type for wayland"
  homepage "https://github.com/atx/wtype"
  url "https://github.com/atx/wtype/archive/refs/tags/v0.5.tar.gz"
  sha256 "684308ac8b47c510dddf4abac3aef86b4f7b8c0e165389a40608679a7a5b77ed"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_linux:  "b42851dcb1be681c7fcd878dbb2dd02e1e3da9bb3d8ce3606129a990673215b4"
    sha256 cellar: :any, x86_64_linux: "3884b208e31bb6afe4dd693c5d1241690d732ba201b715ace851cf54a10d5266"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "libxkbcommon"
  depends_on :linux
  depends_on "wayland"
  depends_on "wayland-protocols"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    assert_match "Wayland connection failed", shell_output("#{bin}/wtype test 2>&1", 1)
  end
end

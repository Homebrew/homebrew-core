class Qtwayland < Formula
  desc "Wayland platform plugin and QtWaylandCompositor API"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.10/6.10.2/submodules/qtwayland-everywhere-src-6.10.2.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.10/6.10.2/submodules/qtwayland-everywhere-src-6.10.2.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.10/6.10.2/submodules/qtwayland-everywhere-src-6.10.2.tar.xz"
  sha256 "391998eb432719df26a6a67d8efdc67f8bf2afdd76c1ee3381ebff4fe7527ee2"
  license all_of: [
    "GPL-3.0-only", # WaylandCompositor
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] }, # WaylandClient
    { "GPL-3.0-only" => { with: "Qt-GPL-exception-1.0" } }, # qtwaylandscanner
    "BSD-3-Clause",      # *.cmake
    "HPND",              # src/3rdparty/protocol/text-input/v2/
    "LGPL-2.1-or-later", # src/3rdparty/protocol/appmenu/
    "MIT",               # src/3rdparty/protocol/
  ]
  head "https://code.qt.io/qt/qtwayland.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "d31469fd73b406d844ec790555ae7ecbd1f76c04808193707b41647c19113588"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "2fe4f64aa2c21c5b6ac5a0f93e8fbf2c340399a6c01f5078f1e8cf4cfb26fc45"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "vulkan-headers" => :build

  depends_on "libxkbcommon"
  depends_on :linux
  depends_on "mesa"
  depends_on "qtbase"
  depends_on "qtdeclarative"
  depends_on "qtsvg"
  depends_on "wayland"

  def install
    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja",
                    "-DCMAKE_STAGING_PREFIX=#{prefix}",
                    *std_cmake_args(install_prefix: HOMEBREW_PREFIX)
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # https://github.com/qt/qtwayland/blob/dev/examples/wayland/minimal-qml/main.qml
    (testpath/"test.qml").write <<~QML
      import QtQuick
      import QtQuick.Window
      import QtWayland.Compositor
      import QtWayland.Compositor.XdgShell
      import QtWayland.Compositor.WlShell
      import QtWayland.Compositor.IviApplication

      WaylandCompositor {
        WaylandOutput {
          sizeFollowsWindow: true
          window: Window {
            width: 1024
            height: 768
            visible: true
            Repeater {
              model: shellSurfaces
              ShellSurfaceItem {
                shellSurface: modelData
                onSurfaceDestroyed: shellSurfaces.remove(index)
              }
            }
          }
        }
        WlShell {
          onWlShellSurfaceCreated: (shellSurface) => shellSurfaces.append({shellSurface: shellSurface});
        }
        XdgShell {
          onToplevelCreated: (toplevel, xdgSurface) => shellSurfaces.append({shellSurface: xdgSurface});
        }
        IviApplication {
          onIviSurfaceCreated: (iviSurface) => shellSurfaces.append({shellSurface: iviSurface});
        }
        ListModel { id: shellSurfaces }
        Timer {
          interval: 2000
          running: true
          onTriggered: Qt.quit()
        }
      }
    QML

    ENV["LC_ALL"] = "en_US.UTF-8"
    ENV["QT_QPA_PLATFORM"] = "minimal"
    ENV["XDG_RUNTIME_DIR"] = testpath
    system Formula["qtdeclarative"].bin/"qml", "test.qml"
  end
end

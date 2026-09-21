class Qtwayland < Formula
  desc "Wayland platform plugin and QtWaylandCompositor API"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.11/6.11.2/submodules/qtwayland-everywhere-src-6.11.2.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.11/6.11.2/submodules/qtwayland-everywhere-src-6.11.2.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.11/6.11.2/submodules/qtwayland-everywhere-src-6.11.2.tar.xz"
  sha256 "8eb7615e39332a10f506e8dd70f02d5954bb5949ff54f6dcbf8bd6168222f9df"
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
    sha256 cellar: :any, arm64_linux:  "775ea167685be2459e2bbf3f73f78d299587cc7b2a5d4a51fea0e0bdd955d05a"
    sha256 cellar: :any, x86_64_linux: "4d251127d6a05d69bbaedf8cd054a5d9748c4c59af37feea50941fc9fc176f11"
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
    system formula_opt_bin("qtdeclarative")/"qml", "test.qml"
  end
end

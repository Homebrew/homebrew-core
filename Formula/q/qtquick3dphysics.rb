class Qtquick3dphysics < Formula
  desc "High-level QML module adding physical simulation capabilities to Qt Quick 3D"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.11/6.11.1/submodules/qtquick3dphysics-everywhere-src-6.11.1.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.11/6.11.1/submodules/qtquick3dphysics-everywhere-src-6.11.1.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.11/6.11.1/submodules/qtquick3dphysics-everywhere-src-6.11.1.tar.xz"
  sha256 "d1086d6f014e7b698945cf0ee1dc3e43545ed7dcf0b5e501c0d6836a96ac79af"
  license all_of: [
    "GPL-3.0-only",
    { "GPL-3.0-only" => { with: "Qt-GPL-exception-1.0" } }, # cooker
    "BSD-3-Clause", # bundled PhysX; *.cmake
  ]
  compatibility_version 1
  head "https://code.qt.io/qt/qtquick3dphysics.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "83e10c8b76ac83647bf79d5f5e522d3b8938c2439a94b7b6de3a9b09dd7aa366"
    sha256 cellar: :any,                 arm64_sequoia: "c08b1c2b69562e5a3f23e240caa1c18209e9118361113fad5805c65eb9c8cdf4"
    sha256 cellar: :any,                 arm64_sonoma:  "e7313eff8b18c1e5996136ce59fbab49da134d3cf2a56b3a3ae3d02a1a3514b4"
    sha256 cellar: :any,                 sonoma:        "28c17c5944cd16f135b3323c4a9e4bdea0d740dcd71ce4d25d41502f099b9f3c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c58f3379e3d67c10c9f7eaf44923f0f2f4d274d705367f708d98b10f3e7a4758"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9d9bfc8e11a2cc4e5fbf907d1a6ff5ac63084185474c9672959e40c04a48b8e"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  depends_on "qtbase"
  depends_on "qtdeclarative"
  depends_on "qtquick3d"

  on_macos do
    depends_on "qtshadertools"
  end

  def install
    args = ["-DCMAKE_STAGING_PREFIX=#{prefix}"]
    args << "-DQT_NO_APPLE_SDK_AND_XCODE_CHECK=ON" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja",
                    *args, *std_cmake_args(install_prefix: HOMEBREW_PREFIX, find_framework: "FIRST")
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Some config scripts will only find Qt in a "Frameworks" folder
    frameworks.install_symlink lib.glob("*.framework") if OS.mac?
  end

  test do
    # https://github.com/qt/qtquick3dphysics/blob/dev/examples/quick3dphysics/simple/main.qml
    (testpath/"test.qml").write <<~QML
      import QtQuick
      import QtQuick3D
      import QtQuick3D.Helpers
      import QtQuick3D.Physics

      Window {
        width: 640
        height: 480
        visible: true

        PhysicsWorld {
          scene: viewport.scene
        }
        View3D {
          id: viewport
          anchors.fill: parent
          environment: SceneEnvironment {
            clearColor: "#d6dbdf"
            backgroundMode: SceneEnvironment.Color
          }
          PerspectiveCamera {
            position: Qt.vector3d(-200, 100, 500)
            eulerRotation: Qt.vector3d(-20, -20, 0)
            clipFar: 5000
            clipNear: 1
          }
          DirectionalLight {
            eulerRotation.x: -45
            eulerRotation.y: 45
            castsShadow: true
            brightness: 1
            shadowFactor: 50
          }
          StaticRigidBody {
            position: Qt.vector3d(0, -100, 0)
            eulerRotation: Qt.vector3d(-90, 0, 0)
            collisionShapes: PlaneShape {}
            Model {
              source: "#Rectangle"
              scale: Qt.vector3d(10, 10, 1)
              materials: PrincipledMaterial {
                baseColor: "green"
              }
              castsShadows: false
              receivesShadows: true
            }
          }
          DynamicRigidBody {
            position: Qt.vector3d(-100, 100, 0)
            collisionShapes: BoxShape {
              id: boxShape
            }
            Model {
              source: "#Cube"
              materials: PrincipledMaterial {
                baseColor: "yellow"
              }
            }
          }
        }
        Timer {
          interval: 2000
          running: true
          onTriggered: Qt.quit()
        }
      }
    QML

    ENV["LC_ALL"] = "en_US.UTF-8"
    ENV["QT_QPA_PLATFORM"] = "minimal" if OS.linux?
    system Formula["qtdeclarative"].bin/"qml", "test.qml"
  end
end

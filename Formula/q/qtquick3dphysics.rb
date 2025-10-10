class Qtquick3dphysics < Formula
  desc "High-level QML module adding physical simulation capabilities to Qt Quick 3D"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.9/6.9.3/submodules/qtquick3dphysics-everywhere-src-6.9.3.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.9/6.9.3/submodules/qtquick3dphysics-everywhere-src-6.9.3.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.9/6.9.3/submodules/qtquick3dphysics-everywhere-src-6.9.3.tar.xz"
  sha256 "dcd7b22d745d249eb602c5d4d8af8a8e9d11217ccb42b3dd611bb047153b5a6e"
  license all_of: [
    "GPL-3.0-only",
    { "GPL-3.0-only" => { with: "Qt-GPL-exception-1.0" } }, # cooker
    "BSD-3-Clause", # bundled PhysX; *.cmake
  ]
  head "https://code.qt.io/qt/qtquick3dphysics.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "821fb7522f7756940c7f86760f31c1d3171a7a2a3c01306c3931fd1c713bc180"
    sha256 cellar: :any,                 arm64_sequoia: "ea3cf9eac77865b8a79a12e4cd4f0ff8617f902307b91ca30072fcb9a0b5dbc0"
    sha256 cellar: :any,                 arm64_sonoma:  "b548ef2824ee560dfeecdd114cc05fe2a0d453f12bc73b185dcaf62a3681799a"
    sha256 cellar: :any,                 sonoma:        "e4390f70dd85beff44fa7fae526836cffe45532c9acff35ec14b55aeaf7db196"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ccdaee4f4fe6eca58805b1aba30d2798c239c6127ce9f8497c1c0d9f4d462c02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10884c823dcc774344c7fb8bfa38d90532ad4bcc8fbe815aeefb912651183faf"
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

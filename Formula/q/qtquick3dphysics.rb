class Qtquick3dphysics < Formula
  desc "High-level QML module adding physical simulation capabilities to Qt Quick 3D"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.10/6.10.2/submodules/qtquick3dphysics-everywhere-src-6.10.2.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.10/6.10.2/submodules/qtquick3dphysics-everywhere-src-6.10.2.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.10/6.10.2/submodules/qtquick3dphysics-everywhere-src-6.10.2.tar.xz"
  sha256 "b7aff67bd05794351d7c19b178c54b674afc3ea2b4632df892aaee98f12c1cdb"
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
    sha256 cellar: :any,                 arm64_tahoe:   "78179ed0b5ae48f69edb42c6f43279742c16aefa3393ed16fde72a25d821b4f6"
    sha256 cellar: :any,                 arm64_sequoia: "042c6d2d7c6c89335d68f7a1a2c66b4c1078f4875ad8d4addbbafa4031405e48"
    sha256 cellar: :any,                 arm64_sonoma:  "206fadd710f4f6077961cc91be56cc6e47a252d3096fe6d972645c8da7e144bf"
    sha256 cellar: :any,                 sonoma:        "0ea745a2f51e4487bfbb89edce65f72498fe807a855223d221e6135b08f1c221"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "809f9f155425ba89dcf6873eb25013662993f5abb461ee35e4178590d5e293f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43d230e0cd2359d8b50d69f095ac1081832cf913f543b26d5ce20866fff3883d"
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

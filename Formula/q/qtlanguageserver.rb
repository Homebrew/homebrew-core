class Qtlanguageserver < Formula
  desc "Implementation of the Language Server Protocol and JSON-RPC"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.10/6.10.2/submodules/qtlanguageserver-everywhere-src-6.10.2.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.10/6.10.2/submodules/qtlanguageserver-everywhere-src-6.10.2.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.10/6.10.2/submodules/qtlanguageserver-everywhere-src-6.10.2.tar.xz"
  sha256 "9a043f2c84b0b470065fc7a954dc4ff0388db3e1b2c457c3d69670baecc40d53"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] },
    "BSD-3-Clause", # *.cmake
  ]
  head "https://code.qt.io/qt/qtlanguageserver.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0b1f74208d42bba8f56aa1b9456a0a4acee9148ccfcb0cfd177a4549181880f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93943b6b16534fb60fdb8cf68d919d060dbcb37041791a4c9abc4263b22bccb3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8dc43760c08666db3f5f19500becd2326b6fe6a9e31ea457c5573230422776fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b2c7d9a8f7ee8f1d6f4ed6612693304ebe7872cf5c69d45ff0578bb2622f182"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e61443471773e7e2ace4a775d9ed961ad976c628e958f011580c2cf281ebac14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b022911f1a36ed912c6cccd95b265be0875cbfb0f4b846aea27606be0ae8368c"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "ninja" => :build

  depends_on "qtbase"

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
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 4.0)
      project(test VERSION 1.0.0 LANGUAGES CXX)
      find_package(Qt6 REQUIRED COMPONENTS JsonRpcPrivate)
      add_executable(test main.cpp)
      target_link_libraries(test PRIVATE Qt6::JsonRpcPrivate)
    CMAKE

    (testpath/"test.pro").write <<~QMAKE
      QT      += jsonrpc_private
      TARGET   = test
      CONFIG  += console
      CONFIG  -= app_bundle
      TEMPLATE = app
      SOURCES += main.cpp
    QMAKE

    (testpath/"main.cpp").write <<~CPP
      #undef QT_NO_DEBUG
      #include <QtJsonRpc/private/qjsonrpctransport_p.h>
      #include <QtJsonRpc/private/qjsonrpcprotocol_p.h>

      class TestTransport : public QJsonRpcTransport {
      public:
        void sendMessage(const QJsonDocument &) final {}
        void receiveData(const QByteArray &) final {}
      };

      int main(void) {
        QJsonRpcProtocol protocol;
        TestTransport transport;
        protocol.setTransport(&transport);
        return 0;
      }
    CPP

    ENV["LC_ALL"] = "en_US.UTF-8"
    ENV["QT_QPA_PLATFORM"] = "minimal" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "cmake", "-S", ".", "-B", "cmake"
    system "cmake", "--build", "cmake"
    system "./cmake/test"

    ENV.delete "CPATH" if OS.mac?
    mkdir "qmake" do
      system Formula["qtbase"].bin/"qmake", testpath/"test.pro"
      system "make"
      system "./test"
    end
  end
end

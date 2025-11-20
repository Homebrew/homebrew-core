class Qtlanguageserver < Formula
  desc "Implementation of the Language Server Protocol and JSON-RPC"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.9/6.9.3/submodules/qtlanguageserver-everywhere-src-6.9.3.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.9/6.9.3/submodules/qtlanguageserver-everywhere-src-6.9.3.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.9/6.9.3/submodules/qtlanguageserver-everywhere-src-6.9.3.tar.xz"
  sha256 "c8e8a6c4f8cb25626922e78f398b13b02eea21c4cc5525ffc2a0da7469369d33"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] },
    "BSD-3-Clause", # *.cmake
  ]
  head "https://code.qt.io/qt/qtlanguageserver.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0d4229ffcdccf46c7de6c85f6c172fe4d32e98c4de97eac26308d325d101285e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "224eff3ca1a5461c2e30e2a2ce2e08255c5ef59e6e155a101fd76f89f0ce3658"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e70336d46487107ec97a74126f4abe4fb81eb376f1fbb44194ee330b690330c"
    sha256 cellar: :any_skip_relocation, sonoma:        "c02e42a854bdce647fbdbee94996bd4ef0527d55768b1a724279d003a4589a66"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38f6f031e539929940c80febf7c5720e4efeae36b98f626a6a9a4ac8be9acca9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f88fd9cdb6fde0da393d684f91fd8d80a7edbbbcce56d33a8131ffa838f464f5"
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

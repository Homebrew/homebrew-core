class Qtlanguageserver < Formula
  desc "Implementation of the Language Server Protocol and JSON-RPC"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.10/6.10.1/submodules/qtlanguageserver-everywhere-src-6.10.1.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.10/6.10.1/submodules/qtlanguageserver-everywhere-src-6.10.1.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.10/6.10.1/submodules/qtlanguageserver-everywhere-src-6.10.1.tar.xz"
  sha256 "3360526b4f4d556673b31e29a49e15d02da52d5eaa53b0204d56a0ba160a556c"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] },
    "BSD-3-Clause", # *.cmake
  ]
  head "https://code.qt.io/qt/qtlanguageserver.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0a6c0e83127c5cbcac9e34ff8612657dbfb2b5a3ee7e94054436578cd1ecb410"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d0d6381178a018d0a7f2b5f3653f6fc2d6535c1322af779a7c88395a4f18c77"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c6c692b3a772db38f231959ec960dc417ad3b9663bb0640e78f08e1647a56938"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc067cf86fdebfc76ee74b26d6dcc3f013bd3151e46685661c96525cf2ba5632"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6cb636613d7b9de1c04041c5f12e5f8fa1a3661983cc95ee3a247e660f0b7cf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bbce2813ad196843221d84a477be941869de3f79571d7d5f0f55f9aeab397652"
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

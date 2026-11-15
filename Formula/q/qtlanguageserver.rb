class Qtlanguageserver < Formula
  desc "Implementation of the Language Server Protocol and JSON-RPC"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.12/6.12.0/submodules/qtlanguageserver-everywhere-src-6.12.0.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.12/6.12.0/submodules/qtlanguageserver-everywhere-src-6.12.0.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.12/6.12.0/submodules/qtlanguageserver-everywhere-src-6.12.0.tar.xz"
  sha256 "552119e37360c06c5fb0b54e91bbfdf8da5a80d2cb1441ef93e966eb3b7a426d"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] },
    "BSD-3-Clause", # *.cmake
  ]
  compatibility_version 1
  head "https://code.qt.io/qt/qtlanguageserver.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fc7b4b78756cd958f876fe68b7b64ebb8ad7027b3fe7f8643c6493928ea3d177"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6afc4fe59493d7b6e9b76d41cd25f2b953340d53bcc45b95f9ba19435bcdfe73"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2276931f0537d7b7f92f926586d631f6ed0b3a5d1c9a4a1c8045d685457ab7be"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e865b32c902f08d00bba8ba4a698f4be508e4d392f8c19a3eb92ddc454f71bd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "a4589da9e77d54e18daab31474180f259ee120c5fff4afa2a6539e166758286a"
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
      system formula_opt_bin("qtbase")/"qmake", testpath/"test.pro"
      system "make"
      system "./test"
    end
  end
end

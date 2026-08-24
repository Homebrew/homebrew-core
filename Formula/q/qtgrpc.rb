class Qtgrpc < Formula
  desc "Provides support for communicating with gRPC services"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.11/6.11.1/submodules/qtgrpc-everywhere-src-6.11.1.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.11/6.11.1/submodules/qtgrpc-everywhere-src-6.11.1.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.11/6.11.1/submodules/qtgrpc-everywhere-src-6.11.1.tar.xz"
  sha256 "437b04f0c550ccdb1739ca5f9119b73dfa0376564815e8bfc199890643e2a250"
  license all_of: [
    "GPL-3.0-only", # QtGrpc
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] }, # QtProtobuf
    { "GPL-3.0-only" => { with: "Qt-GPL-exception-1.0" } }, # qtgrpcgen; qtprotobufgen
    "BSD-3-Clause", # *.cmake
  ]
  revision 5
  compatibility_version 1
  head "https://code.qt.io/qt/qtgrpc.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "2c385df22c143c4fbbd563f7b0d39d290c481e2d4df45bfc9f351fcc50f5ecb2"
    sha256 cellar: :any, arm64_sequoia: "7166ac60117a1655795b8fda7ddc2350f165dfa11f37c81dbefa7a73824f9045"
    sha256 cellar: :any, arm64_sonoma:  "c5a20dc455cd7419a24c3589ad8a2b7dafb312ad86264cfd0a0ee61a6a7c94f8"
    sha256 cellar: :any, sonoma:        "705d12b775f372e4daa964359f8fb65d9164141634d7931bf7c3acb59de4de0d"
    sha256 cellar: :any, arm64_linux:   "b7f694d55ef070466213006987b9272bf7f909059368369d8b4276c03dcc6853"
    sha256 cellar: :any, x86_64_linux:  "2d5bbdca72891d7889214086b99f37f33dec24b6a708f783b0bcbd146b487303"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "ninja" => :build
  depends_on "pkgconf" => :test

  depends_on "abseil"
  depends_on "protobuf"
  depends_on "qtbase"
  depends_on "qtdeclarative"

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
      find_package(Qt6 COMPONENTS Protobuf Grpc)
      qt_standard_project_setup()
      qt_add_executable(clientguide_client main.cpp)
      qt_add_protobuf(clientguide_client PROTO_FILES clientguide.proto)
      qt_add_grpc(clientguide_client CLIENT PROTO_FILES clientguide.proto)
      target_link_libraries(clientguide_client PRIVATE Qt6::Protobuf Qt6::Grpc)
    CMAKE

    (testpath/"clientguide.proto").write <<~PROTO
      syntax = "proto3";
      package client.guide;
      message Request {
        int64 time = 1;
        sint32 num = 2;
      }
      message Response {
        int64 time = 1;
        sint32 num = 2;
      }
      service ClientGuideService {
        rpc UnaryCall (Request) returns (Response);
        rpc ServerStreaming (Request) returns (stream Response);
        rpc ClientStreaming (stream Request) returns (Response);
        rpc BidirectionalStreaming (stream Request) returns (stream Response);
      }
    PROTO

    (testpath/"main.cpp").write <<~CPP
      #include <memory>
      #include <QGrpcHttp2Channel>
      #include "clientguide.qpb.h"
      #include "clientguide_client.grpc.qpb.h"

      int main(void) {
        auto channel = std::make_shared<QGrpcHttp2Channel>(QUrl("http://localhost:#{free_port}"));
        client::guide::ClientGuideService::Client client;
        client.attachChannel(std::move(channel));
        return 0;
      }
    CPP

    system "cmake", "-S", ".", "-B", "."
    system "cmake", "--build", "."
    system "./clientguide_client"
  end
end

class Qtgrpc < Formula
  desc "Provides support for communicating with gRPC services"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.11/6.11.2/submodules/qtgrpc-everywhere-src-6.11.2.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.11/6.11.2/submodules/qtgrpc-everywhere-src-6.11.2.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.11/6.11.2/submodules/qtgrpc-everywhere-src-6.11.2.tar.xz"
  sha256 "44414617f0058ff34965fa852027bfcc7e4f71eefca8cd4406c96af22c64ad93"
  license all_of: [
    "GPL-3.0-only", # QtGrpc
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] }, # QtProtobuf
    { "GPL-3.0-only" => { with: "Qt-GPL-exception-1.0" } }, # qtgrpcgen; qtprotobufgen
    "BSD-3-Clause", # *.cmake
  ]
  revision 1
  compatibility_version 1
  head "https://code.qt.io/qt/qtgrpc.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "79e9cfc012bf51f951071bfba1b549e6db7fe059476ec436d54b7c4a002b3e19"
    sha256 cellar: :any, arm64_sequoia: "9aa5494bc6651e00519b7115d87ab8a15c1a1ccd2e733079d55e26b5f8938f39"
    sha256 cellar: :any, arm64_sonoma:  "093f2477f4bc367a71ffffbe7503252a5362df25b6396fcca9be17e0fdd7db0e"
    sha256 cellar: :any, arm64_linux:   "93b0a82523c49d6255ae9a2f42a90bdde0ab35378e390694c73d1b4ca262fb5f"
    sha256 cellar: :any, x86_64_linux:  "ebcf1da93822da27667f3c28fb950f7d6a33bff460271882686b022ef139bd06"
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

class Qtgrpc < Formula
  desc "Provides support for communicating with gRPC services"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.10/6.10.0/submodules/qtgrpc-everywhere-src-6.10.0.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.10/6.10.0/submodules/qtgrpc-everywhere-src-6.10.0.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.10/6.10.0/submodules/qtgrpc-everywhere-src-6.10.0.tar.xz"
  sha256 "fb722289066101ae08865378e7fb29a22b416a71f6b1c19ae5a957f53a91a445"
  license all_of: [
    "GPL-3.0-only", # QtGrpc
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] }, # QtProtobuf
    { "GPL-3.0-only" => { with: "Qt-GPL-exception-1.0" } }, # qtgrpcgen; qtprotobufgen
    "BSD-3-Clause", # *.cmake
  ]
  head "https://code.qt.io/qt/qtgrpc.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "87c2e77be4bab65bb99e4f573260c65174247381092b99518a2c14f0d8f65769"
    sha256 cellar: :any,                 arm64_sequoia: "233ef57468ad5b651a2d37c8ab975f06d0827a4c11fc12d3dad58761c42d23db"
    sha256 cellar: :any,                 arm64_sonoma:  "5fbd8ba7577a6a7cc06c23b0f1d35423e6871831c108eaccc758945ca67a3b88"
    sha256 cellar: :any,                 sonoma:        "9f0602afced7f21647cf8d548186c9acf92020238ba19084eed864fc30657cbc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ca10aa2fec7703dedb97d06cfbb5bccb1a215b71756cc7f6013b70e0a1a94fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1aa06fdc8411750fe70d995864f44c43b9df825cddea956ded2309d8f324b230"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "ninja" => :build
  depends_on "pkgconf" => :test

  depends_on "abseil"
  depends_on "protobuf"
  depends_on "qtbase"
  depends_on "qtdeclarative"

  # TODO: preserve_rpath # https://github.com/orgs/Homebrew/discussions/2823

  def install
    args = []
    if OS.mac?
      args << "-DQT_EXTRA_RPATHS=#{(HOMEBREW_PREFIX/"lib").relative_path_from(lib)}"
      args << "-DQT_NO_APPLE_SDK_AND_XCODE_CHECK=ON"
    end

    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja", *args, *std_cmake_args(find_framework: "FIRST")
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

    system "cmake", "-S", ".", "-B", ".", "-DCMAKE_BUILD_RPATH=#{HOMEBREW_PREFIX}/lib"
    system "cmake", "--build", "."
    system "./clientguide_client"
  end
end

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
  revision 1
  head "https://code.qt.io/qt/qtgrpc.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "024146b259e09d6a9b08e4ce0476a159e9f630d510a3c6cc3a74649dff6f9328"
    sha256 cellar: :any,                 arm64_sequoia: "1ca2018114dda5ad5ce0be7bfe2d56414222f2bbebe5d89bfceca07ce710e917"
    sha256 cellar: :any,                 arm64_sonoma:  "ec2fb21e611a02008d174bd22ec22c172e3687b6e5013146db227ebd39e69dc1"
    sha256 cellar: :any,                 sonoma:        "82d423e172d378e8d8acf454ed82add86279dc7793b9eca9ef9bb95b6b25c8ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "58c4c6ad6149807a3c7a41f2a2074feef44c6c1fbcc3685245c1ae42a6e022ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cad946ebb98bdd45217d6aee72ecaeba59554aaaed4e1b33c1a3083449908e34"
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

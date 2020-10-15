class SwiftProtobuf < Formula
  desc "Plugin and runtime library for using protobuf with Swift"
  homepage "https://github.com/apple/swift-protobuf"
  url "https://github.com/apple/swift-protobuf/archive/1.12.0.tar.gz"
  sha256 "f50dae44d998b49c271bf9288f2e1ff564bb950d8f276b43dce2a82079b22e25"
  license "Apache-2.0"
  head "https://github.com/apple/swift-protobuf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8e0c5c972d8fcbec4dd24a934db1959cb77ada83b2a2ef1722c8a32e00f72861" => :catalina
    sha256 "7e24b3de0ab310de9816f40457c4928034b1f2e18661fd6d0576ad906deae7d1" => :mojave
    sha256 "d52bc630a57e4cac6eee86bdcf4b7f1c4af166f468e9ab79e8298bc008d6ddbc" => :high_sierra
  end

  depends_on xcode: ["8.3", :build]
  depends_on "protobuf"

  conflicts_with "protobuf-swift",
    because: "both install `protoc-gen-swift` binaries"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/protoc-gen-swift"
    doc.install "Documentation/PLUGIN.md"
  end

  test do
    (testpath/"test.proto").write <<~EOS
      syntax = "proto3";
      enum Flavor {
        CHOCOLATE = 0;
        VANILLA = 1;
      }
      message IceCreamCone {
        int32 scoops = 1;
        Flavor flavor = 2;
      }
    EOS
    system Formula["protobuf"].opt_bin/"protoc", "test.proto", "--swift_out=."
    assert_predicate testpath/"test.pb.swift", :exist?
  end
end

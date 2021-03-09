class SwiftProtobuf < Formula
  desc "Plugin and runtime library for using protobuf with Swift"
  homepage "https://github.com/apple/swift-protobuf"
  url "https://github.com/apple/swift-protobuf/archive/1.15.0.tar.gz"
  sha256 "e9b4d467e67692708f6a2cfc78372156f3945ba5fdd21a3c799fa2c29b150563"
  license "Apache-2.0"
  revision 1
  head "https://github.com/apple/swift-protobuf.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "22319befbba8c0cd170d31342957469f73a0af90be39e2aa6f27b6ba4ec1bf54"
    sha256 cellar: :any_skip_relocation, big_sur:       "04a76e3cade018871acf0f19b7764d5d398f1e1302fbfe7157a56a776f2c8e12"
    sha256 cellar: :any_skip_relocation, catalina:      "9877fa712cedfba58ea291afb38daf1cfc22a97adfc277944eb1213257e6bbaf"
    sha256 cellar: :any_skip_relocation, mojave:        "4aa49d0388ad38fe94e589f8a250a159c03f5d086576cb1fbfb9b59c7775fb1c"
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

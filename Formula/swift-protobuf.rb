class SwiftProtobuf < Formula
  desc "Plugin and runtime library for using protobuf with Swift"
  homepage "https://github.com/apple/swift-protobuf"
  url "https://github.com/apple/swift-protobuf/archive/1.11.0.tar.gz"
  sha256 "d576e0e411aae3a956bf919a538ddd9f0318e3be3c3e4c1fcf557802c01a930c"
  license "Apache-2.0"
  head "https://github.com/apple/swift-protobuf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6c97ae7cc3cd4652ec7837760f9e5d5670d7b8e9e1d2dc072c8068b7492e593a" => :catalina
    sha256 "f5a8dd288883b04d0c0dbb41383b7d617de3bb9c5552d7f18ebad7ed2919c476" => :mojave
    sha256 "a8e4f0a5ce4906cc4a502a6b05bd5ed4505f84048dda3584f77529cf0b9cbf4d" => :high_sierra
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

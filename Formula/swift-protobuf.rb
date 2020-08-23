class SwiftProtobuf < Formula
  desc "Plugin and runtime library for using protobuf with Swift"
  homepage "https://github.com/apple/swift-protobuf"
  url "https://github.com/apple/swift-protobuf/archive/1.11.0.tar.gz"
  sha256 "d576e0e411aae3a956bf919a538ddd9f0318e3be3c3e4c1fcf557802c01a930c"
  license "Apache-2.0"
  head "https://github.com/apple/swift-protobuf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4259c61f3f84f0a477c7eb3ca8efcdccd5410d21f02bd98f73212dae951fe0f3" => :catalina
    sha256 "5ad817b5948e2cdcd2796bfb4ed1536b271c38a0a0e76fe7c3bc682beee40624" => :mojave
    sha256 "472296f0d6cd5197ed720665ec6e670391e8f315292579531ca4cb700caebe33" => :high_sierra
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

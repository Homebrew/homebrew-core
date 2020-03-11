class SwiftProtobuf < Formula
  desc "Plugin and runtime library for using protobuf with Swift"
  homepage "https://github.com/apple/swift-protobuf"
  url "https://github.com/apple/swift-protobuf/archive/1.8.0.tar.gz"
  sha256 "73e1d2e749db23f8d39636a462a463926225e390a7220a65b28fa173ac831a46"
  head "https://github.com/apple/swift-protobuf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1f0ba0b14f54d0a3c12fa0896b386ef58d48dbbb5261024ef81bd7c592db438b" => :catalina
    sha256 "ea096eab639299416918e255d615aadb6cbb56aca56be28f892b0a7f293a46a9" => :mojave
    sha256 "4ee242478ba9836401c63f4c7a920e0ed62a7ff483362a6352250b0509afb1d4" => :high_sierra
  end

  depends_on :xcode => ["8.3", :build]
  depends_on "protobuf"

  conflicts_with "protobuf-swift",
    :because => "both install `protoc-gen-swift` binaries"

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

class SwiftProtobuf < Formula
  desc "Plugin and runtime library for using protobuf with Swift"
  homepage "https://github.com/apple/swift-protobuf"
  url "https://github.com/apple/swift-protobuf/archive/1.0.0.tar.gz"
  sha256 "9cb811d608294d7b5fd0dcdc78d5b66b7ac2005ec026db3530f563be4248656a"
  head "https://github.com/apple/swift-protobuf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "42b8f197acbc35e43f873288d87585c8547d2f2f070c7ef26475a68a5bde3ce8" => :high_sierra
    sha256 "2f1d6e97d045138edaa1b7f64bdbfd852a7865464b8b5bc7ae9bf44cc94fe224" => :sierra
  end

  depends_on :xcode => ["8.3", :build]
  depends_on "protobuf"

  conflicts_with "protobuf-swift",
    :because => "both install `protoc-gen-swift` binaries"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release", "-Xswiftc",
           "-static-stdlib"
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

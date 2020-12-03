class SwiftProtobuf < Formula
  desc "Plugin and runtime library for using protobuf with Swift"
  homepage "https://github.com/apple/swift-protobuf"
  url "https://github.com/apple/swift-protobuf/archive/1.14.0.tar.gz"
  sha256 "3bb458ab12170f7f19c7441fea5f72ed6642a0898f40adcb678e385d7d97c97c"
  license "Apache-2.0"
  head "https://github.com/apple/swift-protobuf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bb7e9ad3489f0186544c96e4d910774bf692f895d8723b1740dd6e84b6c3d067" => :big_sur
    sha256 "64116ec2abcfacf8e1712190b07a404d0c5fe721bb5f8722c8d561b5d286b813" => :catalina
    sha256 "5b173998fd4173eb2dc93f7357d03720f51bfdf95496c545cc73886b4a9e46c3" => :mojave
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

class SwiftProtobuf < Formula
  desc "Plugin and runtime library for using protobuf with Swift"
  homepage "https://github.com/apple/swift-protobuf"
  url "https://github.com/apple/swift-protobuf/archive/1.10.2.tar.gz"
  sha256 "2a7ed5d3b971020d4eaacb2b5739cdd52a0e71a764c468ddff28978ac3499478"
  license "Apache-2.0"
  head "https://github.com/apple/swift-protobuf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fd5ca2f8800c42f092cfc9330b6a234f0afbb52f7043bd8c16f9685ed9e6dcac" => :catalina
    sha256 "3cb7245001419bcc10af467f3f69c40beceff5064165769eba8b17457c514e73" => :mojave
    sha256 "c9f6bc66f804ab2c36d03c2b1ed06527abbba6c88912bc5e3992abf94bfce40f" => :high_sierra
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

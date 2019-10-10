class SwiftProtobuf < Formula
  desc "Plugin and runtime library for using protobuf with Swift"
  homepage "https://github.com/apple/swift-protobuf"
  url "https://github.com/apple/swift-protobuf/archive/1.7.0.tar.gz"
  sha256 "3654f75d1de8806678ea7c942903a6fcdaba477e0fc0a53439cdc381a5f3e4c0"
  head "https://github.com/apple/swift-protobuf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "dd7e62ff6929cfce41f72e596667f633097c41f9bb5142a5545dc5696824e5d6" => :mojave
    sha256 "52d39d3e234c865658b96201738a9236367acfb3b52d2b853accc2e64dde8cb4" => :high_sierra
    sha256 "f61ef93afbb280b55d000cdaab4c78c19dd0c26ebe81e93942b715b24c9b00f9" => :sierra
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

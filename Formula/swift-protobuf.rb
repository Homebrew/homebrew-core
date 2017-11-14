class SwiftProtobuf < Formula
  desc "Plugin and runtime library for using protobuf with Swift"
  homepage "https://github.com/apple/swift-protobuf"
  url "https://github.com/apple/swift-protobuf/archive/1.0.1.tar.gz"
  sha256 "2398da2bcd57c4c6fd895f975c059506839831f00a92b7cb5b4da2183888dca2"
  revision 1
  head "https://github.com/apple/swift-protobuf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "abe5ab09824a7340e3cb3a0e8c4d02fcccf7f66e1f935d7622a8d7d8f906e4a0" => :high_sierra
    sha256 "97352ba5e15f5c8db522e037f807a9770bcfc451c12741b7c5c32a6a518fd945" => :sierra
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

class SwiftProtobuf < Formula
  desc "Plugin and runtime library for using protobuf with Swift"
  homepage "https://github.com/apple/swift-protobuf"
  url "https://github.com/apple/swift-protobuf/archive/1.17.0.tar.gz"
  sha256 "f3e839bb445edcbf1aeb52ce6f24ae52a16cf5c45efb1721633b4d0c73ecc537"
  license "Apache-2.0"
  revision 1
  head "https://github.com/apple/swift-protobuf.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cb748802d8003aeb15560b1a4d9f657d1e3bd2d1d11118f7f74783a0b1e3377e"
    sha256 cellar: :any_skip_relocation, big_sur:       "9b8739dc74b50675ca4c81fa32d1fd143b4f7939b8a89d6c0b92ae7ff82c1edb"
    sha256 cellar: :any_skip_relocation, catalina:      "878d81a48ecea0fc8141715f757ab63e1a875878a79ce212cbb74d6709a59c41"
    sha256 cellar: :any_skip_relocation, mojave:        "8e960d436e3cf9f1381da7baef8d0dcca00b78764b5da2f36abcc9ef48f58884"
  end

  depends_on xcode: ["8.3", :build]
  depends_on "protobuf"

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

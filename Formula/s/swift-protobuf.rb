class SwiftProtobuf < Formula
  desc "Plugin and runtime library for using protobuf with Swift"
  homepage "https://github.com/apple/swift-protobuf"
  url "https://github.com/apple/swift-protobuf/archive/refs/tags/1.28.2.tar.gz"
  sha256 "d086deab3ca0b74751fcc1905d268697b0d471e747fb50eced94941f28b35fb8"
  license "Apache-2.0"
  head "https://github.com/apple/swift-protobuf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da0535ffa864494c03ba844f4918b4cfbac343fd09ab7234c294154cc3b506f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cad09e11827f8cf026449a026abfc9ba1e11a0c90b34f5a2b735d846cc8b9115"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "34c77ac746b7fd3edd9f3cacae83d2f1da2e5c345298ef96a1d8a1185687dae1"
    sha256 cellar: :any_skip_relocation, sonoma:        "f5bc99bcac0e6303d42cb4b4cbd1e81e5fec1effcd26397d06f769729f12a550"
    sha256 cellar: :any_skip_relocation, ventura:       "8f4d5f91c770072daf5fdfbbc7dada661640473ffb9260cc3eca4c96a3512c24"
    sha256                               x86_64_linux:  "81e4a66de12ef234d2b4b0bfe4304323536662d957497ba395e1fb27c1ac6ac3"
  end

  depends_on xcode: ["14.3", :build]
  depends_on "protobuf"

  uses_from_macos "swift"

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

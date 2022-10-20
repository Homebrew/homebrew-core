class SwiftProtobuf < Formula
  desc "Plugin and runtime library for using protobuf with Swift"
  homepage "https://github.com/apple/swift-protobuf"
  url "https://github.com/apple/swift-protobuf/archive/1.20.2.tar.gz"
  sha256 "3fb50bd4d293337f202d917b6ada22f9548a0a0aed9d9a4d791e6fbd8a246ebb"
  license "Apache-2.0"
  head "https://github.com/apple/swift-protobuf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf4961d3753d541afa22d0c41ac2c53ab3e7a99e798d8890dd8959f5873bfba4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1e4dcad6041c37ee285949f43dda5194c2661d11682ac046c4f626e32234811a"
    sha256 cellar: :any_skip_relocation, monterey:       "b92430ab9f117dc5e5e1f43572acbf5b5ba269709370d5fbe086620d77c96b14"
    sha256 cellar: :any_skip_relocation, big_sur:        "69c57badc90be8d7f1067f858cfcc93105b6185406fbe57fb79a66a07cfbb4bf"
    sha256 cellar: :any_skip_relocation, catalina:       "2fbca410cd4fe40f3a17951edddbe4f7ebbbc1b081f15abac1f1c50a8d60a76f"
    sha256                               x86_64_linux:   "c0d820d16f2973953d8c392dcb287b91259e2e885a9b5e0eee14e0976ff952c0"
  end

  depends_on xcode: ["8.3", :build]
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

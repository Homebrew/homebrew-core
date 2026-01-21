class SwiftProtobuf < Formula
  desc "Plugin and runtime library for using protobuf with Swift"
  homepage "https://github.com/apple/swift-protobuf"
  # We use a git checkout as swift needs to find submodule files specified
  # in Package.swift even though they aren't built for `protoc-gen-swift`
  url "https://github.com/apple/swift-protobuf.git",
      tag:      "1.33.3",
      revision: "c169a5744230951031770e27e475ff6eefe51f9d"
  license "Apache-2.0"
  revision 1
  head "https://github.com/apple/swift-protobuf.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3a32be009d86d6036cbbb479ce8227c18dcd11be2d89f8f05eef786a28b833e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87f9a335ff416b9a570696ecaf2bc3a0f43ac7fb9bd1fdf997a2b881edab150b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a32217fb6d0aa99535b3f82d72fac27095951f5e6ae89f477d1d9f68d9deb5e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9633c9d59870b993eb1162708d7a9f8c55e876a983f1b5a58794346af3843a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e9ab00dfec6d4ed4e1e1470b3fff73d4b56a583101bf474d04b9b5d7822d462"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "690370edd5342774a68db5f9be55f57e2d84adfdd6708dbc805dc719634c2427"
  end

  depends_on xcode: ["15.3", :build]
  depends_on "protobuf"

  uses_from_macos "swift" => :build

  def install
    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib"]
    end
    system "swift", "build", *args, "-c", "release", "--product", "protoc-gen-swift"
    bin.install ".build/release/protoc-gen-swift"
    doc.install "Documentation/PLUGIN.md"
  end

  test do
    (testpath/"test.proto").write <<~PROTO
      syntax = "proto3";
      enum Flavor {
        CHOCOLATE = 0;
        VANILLA = 1;
      }
      message IceCreamCone {
        int32 scoops = 1;
        Flavor flavor = 2;
      }
    PROTO
    system Formula["protobuf"].opt_bin/"protoc", "test.proto", "--swift_out=."
    assert_path_exists testpath/"test.pb.swift"
  end
end

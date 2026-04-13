class SwiftProtobuf < Formula
  desc "Plugin and runtime library for using protobuf with Swift"
  homepage "https://github.com/apple/swift-protobuf"
  # We use a git checkout as swift needs to find submodule files specified
  # in Package.swift even though they aren't built for `protoc-gen-swift`
  url "https://github.com/apple/swift-protobuf.git",
      tag:      "1.36.1",
      revision: "a008af1a102ff3dd6cc3764bb69bf63226d0f5f6"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/apple/swift-protobuf.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "962357c54697ef0b68e53275180366324f6a3dfc1f0326d8fb0378703f4efcc9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89a228b39f319f3664c1d1bd5f1c68f06d74b18a718878cab4dd9a6f82bd387d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e6c3757ce0959b9954cc7d1d430484300f80b61f259efed2935ac33057985a60"
    sha256 cellar: :any_skip_relocation, sonoma:        "783894ca4a5261c06863ce2845ecb1d38296aa8682cda329487d66593420be02"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "70cc31ea8f8aec3f9312533bcc4d8aad951d71e1f4579ace586c75b2632cc340"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "247121346cdabbc667e686b09343a4a87432a5dd66662dbf8dcfcb3f001ff144"
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

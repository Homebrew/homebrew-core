class SwiftProtobuf < Formula
  desc "Plugin and runtime library for using protobuf with Swift"
  homepage "https://github.com/apple/swift-protobuf"
  # We use a git checkout as swift needs to find submodule files specified
  # in Package.swift even though they aren't built for `protoc-gen-swift`
  url "https://github.com/apple/swift-protobuf.git",
      tag:      "1.33.3",
      revision: "c169a5744230951031770e27e475ff6eefe51f9d"
  license "Apache-2.0"
  head "https://github.com/apple/swift-protobuf.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "50654e9566975d95f0c552bee7d783cd9d4108e6e5be9ec57c3fdc466b89ec9e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d723caa8a22e380d5b2a5acb7ab6d7a620228ff0b69e40594eac4bc15f2cf38"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0408c6a1c87c54d9f7514a3f3bca78cb3aa5885f21bd9f4d753e14510c8f3730"
    sha256 cellar: :any_skip_relocation, sonoma:        "c37a3df3293459674743b9c37f0f081711298047ad55392db0831ce6ac3c2a3e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a06efea4b040d5b2de90244dac011a69064c02ea00ac217d473a8671bf639701"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15fd838a3f33a216008d578bc6176d7ba9f263e38ab0ce79d615015459227d0c"
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

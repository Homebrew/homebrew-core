class SwiftProtobuf < Formula
  desc "Plugin and runtime library for using protobuf with Swift"
  homepage "https://github.com/apple/swift-protobuf"
  # We use a git checkout as swift needs to find submodule files specified
  # in Package.swift even though they aren't built for `protoc-gen-swift`
  url "https://github.com/apple/swift-protobuf.git",
      tag:      "1.39.0",
      revision: "3d537cb81aef272a03cb3be815439e9bf0eb3bd3"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/apple/swift-protobuf.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c36fe0110251be806be013a57013efc95178bc5aecace8043088551f007b9f7c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "23e2a614c306c04d56c8efb2ceba53d9451c3a8d53e16542aefebb3e206fc7dd"
    sha256 cellar: :any,                 arm64_sequoia:     "0df15f5637eb488c691c5d59ab466b23d150a56ab3f795ea5f77ee693093810d"
    sha256 cellar: :any,                 arm64_linux:       "646512d0fcb762fa964cb22ab210bad51823c5baf732c32c785eabbda6603e7d"
    sha256 cellar: :any,                 x86_64_linux:      "373019a3b45b5613e8c9709e35ece9764ee4499ed8579bf01a2d5745b6d15e4d"
  end

  depends_on "protobuf"

  uses_from_macos "swift" => :build, since: :tahoe # swift 6.2+

  on_macos do
    depends_on xcode: ["15.3", :build]
  end

  deny_network_access!

  def fetch
    # SwiftPM tries to apply its own sandbox, which cannot nest inside the
    # build sandbox; Homebrew's sandbox still confines the whole process.
    system "swift", "package", "resolve", "--disable-sandbox"
  end

  def install
    system "swift", "build", "--product", "protoc-gen-swift", *std_swift_args
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
    system formula_opt_bin("protobuf")/"protoc", "test.proto", "--swift_out=."
    assert_path_exists testpath/"test.pb.swift"
  end
end

class SwiftProtobuf < Formula
  desc "Plugin and runtime library for using protobuf with Swift"
  homepage "https://github.com/apple/swift-protobuf"
  # We use a git checkout as swift needs to find submodule files specified
  # in Package.swift even though they aren't built for `protoc-gen-swift`
  url "https://github.com/apple/swift-protobuf.git",
      tag:      "1.41.0",
      revision: "fed2f76413026cb0ae90999a8c9116949dfe6aa6"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/apple/swift-protobuf.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5a381e7a32d29722c1b71e3c28f6203846d589c2bae75a457ea954c2158f71b3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2be933e858ee1a4c059147b92a14dddf89c4d66421b64901e27ed8b2fbbb69fd"
    sha256 cellar: :any,                 arm64_sequoia:     "1d1b10040f31ea241f672c6a183616d3c9c7d67fcc77364297a9db4985bc9301"
    sha256 cellar: :any,                 arm64_linux:       "cb176a2087cd025111df8a13b689cf2598bb45b9f2512450704d45b4db016072"
    sha256 cellar: :any,                 x86_64_linux:      "a5c2f98f6054784b23acb2c5317346510947ef96fab80666648eeecd377ea6a0"
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

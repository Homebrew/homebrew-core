class SwiftProtobuf < Formula
  desc "Plugin and runtime library for using protobuf with Swift"
  homepage "https://github.com/apple/swift-protobuf"
  # We use a git checkout as swift needs to find submodule files specified
  # in Package.swift even though they aren't built for `protoc-gen-swift`
  url "https://github.com/apple/swift-protobuf.git",
      tag:      "1.40.0",
      revision: "c7d117246c8cd5f93daa873a68659cfe23c93a1e"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/apple/swift-protobuf.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ac2b91c79befeaeb1da0910556bdc6efc6020e66e37440d3898a7a0d507e2778"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "da9e400cd752ac4d5e3c205d19fbc837f9d8e02e31b48fd3d9e144324015ba74"
    sha256 cellar: :any,                 arm64_sequoia:     "c84e1bd129bdc56887939bb9acf66790c68efaefdc7f3b54a60621cc92607b96"
    sha256 cellar: :any,                 arm64_linux:       "932049f5cdc032e920badbcfd1462b439a844ce8860da2e8601c563be37faac1"
    sha256 cellar: :any,                 x86_64_linux:      "b7c3aa04df8551284404b238ee0f8c55d4f10470c9478f31d5ee598c74e83182"
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

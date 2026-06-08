class SwiftProtobuf < Formula
  desc "Plugin and runtime library for using protobuf with Swift"
  homepage "https://github.com/apple/swift-protobuf"
  # We use a git checkout as swift needs to find submodule files specified
  # in Package.swift even though they aren't built for `protoc-gen-swift`
  url "https://github.com/apple/swift-protobuf.git",
      tag:      "1.38.0",
      revision: "f6506eaa86ed2e01cb0ae14a75035b7fdbf0918f"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/apple/swift-protobuf.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "60ce603d56649b5288375363d9c043eef7114a03b2c572e266e5fa429ccaa242"
    sha256 cellar: :any,                 arm64_sequoia: "35674b8dbabe16d36855723223fe423ab41e1ab3d610866b2e17fb308770c666"
    sha256 cellar: :any,                 arm64_sonoma:  "8f436f74f92c474efea8aeb0ccd1be3965d00346018bffd5326e020b46562526"
    sha256 cellar: :any,                 sonoma:        "e1b4ccd98127e8a9dfa07b72fd8acb3e36dd57f455ad68f49289fb73308838bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4b4f73cf4261eb1101f4b58dc728cd1fef54eb5600ef66c5108ea36a8a9901f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32bc416171819a4f81f6edf393301c0d05e12ce76331f7a07d103ddbae4aaf1b"
  end

  depends_on xcode: ["15.3", :build]
  depends_on "protobuf"

  uses_from_macos "swift" => :build, since: :tahoe # swift 6.2+

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

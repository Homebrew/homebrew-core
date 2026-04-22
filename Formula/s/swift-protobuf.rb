class SwiftProtobuf < Formula
  desc "Plugin and runtime library for using protobuf with Swift"
  homepage "https://github.com/apple/swift-protobuf"
  # We use a git checkout as swift needs to find submodule files specified
  # in Package.swift even though they aren't built for `protoc-gen-swift`
  url "https://github.com/apple/swift-protobuf.git",
      tag:      "1.37.0",
      revision: "81558271e243f8f47dfe8e9fdd55f3c2b5413f68"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/apple/swift-protobuf.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "37bdf0189e982bfe3033bfed7f13fdae57b5815037338d2de0bddf0447b1d7a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ef584da05d68e9290c010423bbfb81ec16695080aa980a032fd9c4196ad0046"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "084e3e4e10e3f91a6d5b6e8ab6718bae7c0abbff0e635342b3c1bf88ec951297"
    sha256 cellar: :any_skip_relocation, sonoma:        "2cf081900ff5ccecb8bfafb34aa8fc9579d6b21c36ad70df39e7725cf4b2877f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "60f674b664e567a75b44a40e4fc9de1952258a5ace4ae060e01665f935ecd141"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ad65a59a467ea3257d99cb7d5901efbaf01ff2161a41a2045fa6d020e504235"
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

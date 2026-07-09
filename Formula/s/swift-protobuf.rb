class SwiftProtobuf < Formula
  desc "Plugin and runtime library for using protobuf with Swift"
  homepage "https://github.com/apple/swift-protobuf"
  # We use a git checkout as swift needs to find submodule files specified
  # in Package.swift even though they aren't built for `protoc-gen-swift`
  url "https://github.com/apple/swift-protobuf.git",
      tag:      "1.38.1",
      revision: "55d7a1cc5666b85c13464aea1c4b4a90feccb4c8"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/apple/swift-protobuf.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dd308cfd89ea68cf72d0d130ccdc773c0adfd86d42fb55b6a44ce5c87559039e"
    sha256 cellar: :any,                 arm64_sequoia: "63c34902dcefc19a21b73305eddbed302fc0f0249cef627a42f7464dda56302c"
    sha256 cellar: :any,                 arm64_sonoma:  "6fbd774bc450ad1354541862023ee17fe6518eadd7b88ba1f16f707e5a946af1"
    sha256 cellar: :any,                 sonoma:        "9390976d32cb39f0d98d0238fc0147a81631f00431c02fe7cc36dbce5a49496f"
    sha256 cellar: :any,                 arm64_linux:   "6166b41119d66e67a0f2a04e3d27f91f0c763db111826627d069d34f6bbdd0a0"
    sha256 cellar: :any,                 x86_64_linux:  "a17c7080d57615cc7ec58cf2c327b21978600e666f2bd5e46b7d730f171140d8"
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
    system formula_opt_bin("protobuf")/"protoc", "test.proto", "--swift_out=."
    assert_path_exists testpath/"test.pb.swift"
  end
end

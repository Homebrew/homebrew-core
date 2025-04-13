class SwiftProtobuf < Formula
  desc "Plugin and runtime library for using protobuf with Swift"
  homepage "https://github.com/apple/swift-protobuf"
  url "https://github.com/apple/swift-protobuf/archive/refs/tags/1.29.0.tar.gz"
  sha256 "0a37b1f0aab5aca1e47d0729b878004a4e3c1d5a79ad9aedc51b62d19d36f67d"
  license "Apache-2.0"
  head "https://github.com/apple/swift-protobuf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d11f47bfbbbdf427ae5af21ccc1165e77d2cfc851db714b01ab2dbac764c1520"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d013a8dca6f3acace6deb1a55bc9e170429cdbb6bc1765e7bd8abe6051d14498"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2600bb6e8d77d8ad51b7d00bbb05c2648f1cde0a67076ec1735fbbf6b13b90dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "876fb05e81951bc16d828cd4b6fc6eec24132ca96900b35f4310f617180a4275"
    sha256 cellar: :any_skip_relocation, ventura:       "2a684814cc304f25e1ea59d3079dd6835b6701d84946919db538f76caf1d87c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4150b8bbb82cb4ea9f4cc3a346ae22a5cf11fdc144003931dce837dba50e4a35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6dc45f84a76c05d6fc9060801d94394a46b8e3bb541161d6aeef4f160f29b2b"
  end

  depends_on xcode: ["14.3", :build]
  depends_on "protobuf"

  uses_from_macos "swift" => :build

  def install
    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib"]
    end
    system "swift", "build", *args, "-c", "release"
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

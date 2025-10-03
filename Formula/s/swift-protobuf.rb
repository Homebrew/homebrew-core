class SwiftProtobuf < Formula
  desc "Plugin and runtime library for using protobuf with Swift"
  homepage "https://github.com/apple/swift-protobuf"
  url "https://github.com/apple/swift-protobuf/archive/refs/tags/1.31.1.tar.gz"
  sha256 "e34a0b82c8d07184f7bf3c50c97b8cd4ba0351236a8673ea434af4ce11ac1446"
  license "Apache-2.0"
  head "https://github.com/apple/swift-protobuf.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3742ea13e69e4edb46f0f9bd2718f3b98cde6548a1a34c2fa7c68f2565c18d10"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43696ac7c329ecb74e45bf3af57c93b5bd8c8b379962cfb0599406774b65f38a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81473fbf488b2080d4d350a4fc0956c655cd84e68b324fd259517e75aef63754"
    sha256 cellar: :any_skip_relocation, sonoma:        "225ed48daeb016db92c0070a6b27b3a6fc896a0042b2fa46254a781594b8f6f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32c35d77fb868a9d18c2e5eef7a0d2c5e8ef67fa3c07c0745e718c3650202045"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6bd814eee9399c834308f413cf4369a82397d76b4951be26dc57f68bec312509"
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

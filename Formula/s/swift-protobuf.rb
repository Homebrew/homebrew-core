class SwiftProtobuf < Formula
  desc "Plugin and runtime library for using protobuf with Swift"
  homepage "https://github.com/apple/swift-protobuf"
  url "https://github.com/apple/swift-protobuf/archive/refs/tags/1.25.2.tar.gz"
  sha256 "7d269be07c0bc5e53171c50f577f8d515701c54408c21573c454dfcec68f46a0"
  license "Apache-2.0"
  head "https://github.com/apple/swift-protobuf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e8415af3a2c04d9e6eab74849a09da6b35e4d6c97818f1f037a0bf7ef3a38144"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c1ac62b50cee441485063ae04a72039c92676b1405178a5aa28b7450ebca662e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5442246488060d46fdf343fa5262388aff3fe8198c27844344ad5251b1e8e32a"
    sha256 cellar: :any_skip_relocation, sonoma:         "d02e4d049a763037a8e95582faa75c58bbb0f79cf0f88d09eac0a213d243fc8e"
    sha256 cellar: :any_skip_relocation, ventura:        "38a6307ab4e4dd0e10184420045002069294eaa2359a3336e0168d58196ff717"
    sha256 cellar: :any_skip_relocation, monterey:       "fe3caf8dced3f5d690ea13d73642b1bc88a2489b17772c247a2cba73dd6b70a2"
    sha256                               x86_64_linux:   "45c9ad6a0ecf791bf8d6efaf5d56e18aaa490ed0e1ed613ecaf04cf9dbb83924"
  end

  depends_on xcode: ["8.3", :build]
  depends_on "protobuf"

  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/protoc-gen-swift"
    doc.install "Documentation/PLUGIN.md"
  end

  test do
    (testpath/"test.proto").write <<~EOS
      syntax = "proto3";
      enum Flavor {
        CHOCOLATE = 0;
        VANILLA = 1;
      }
      message IceCreamCone {
        int32 scoops = 1;
        Flavor flavor = 2;
      }
    EOS
    system Formula["protobuf"].opt_bin/"protoc", "test.proto", "--swift_out=."
    assert_predicate testpath/"test.pb.swift", :exist?
  end
end

class SwiftProtobuf < Formula
  desc "Plugin and runtime library for using protobuf with Swift"
  homepage "https://github.com/apple/swift-protobuf"
  url "https://github.com/apple/swift-protobuf/archive/1.21.0.tar.gz"
  sha256 "48f58cd353f8e9110e5b2ffa27872a17d369740927079d7661e4b2c5058fa4eb"
  license "Apache-2.0"
  head "https://github.com/apple/swift-protobuf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4ab81cd57fa5d4e0deceb37a6f8154358487993feb4e285b6a89b2ff64696b1e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ffd933a75cd2ffed9df15963280d588f52fdbe16406ec717b68e9cf949d06de7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d4b88c2de6a47a6dbfd5610a8593fa4a02a3a0873c61b3a3c475aa94b70d4c55"
    sha256 cellar: :any_skip_relocation, ventura:        "9316fe689efc7fb59bb3054b6d46129e77b22d1be37b26a2e2699f90fc02a65d"
    sha256 cellar: :any_skip_relocation, monterey:       "3379e66262839bcbd26a18a6bc45905753b8843fe859b6dc87df9136a5155f44"
    sha256 cellar: :any_skip_relocation, big_sur:        "caeeced8da8117c23ae74c10ff7fc6df514b87fa62fe7420ad8d771aa2bfdb15"
    sha256                               x86_64_linux:   "b4d312e67d6c85613a57ee2e030a25b398bdd98da2bbde591597f953a31da8a7"
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

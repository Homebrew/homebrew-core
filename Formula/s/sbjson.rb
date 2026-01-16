class Sbjson < Formula
  desc "JSON CLI parser & reformatter based on SBJson v5"
  homepage "https://github.com/SBJson/SBJson"
  url "https://github.com/SBJson/SBJson/archive/refs/tags/v5.0.3.tar.gz"
  sha256 "9a03f6643b42a82300f4aefcfb6baf46cc2c519f1bb7db3028f338d6d1c56f1b"
  license "BSD-3-Clause"
  head "https://github.com/SBJson/SBJson.git", branch: "trunk"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "454bec6b83f7734cc9b882e1270baedd9f23d798dde872de9ac6ec7c938bafb5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "217c356def1ddd0b9d9bc1d6bc12966315a41e7a10a029b39460b5becfd1521b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2a4df626840987db1cc6e63599b28909887644147ecb2c76cff994a9cc2d26cd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a9198287e6912393936ae4881bc483e6afcce1f9ae9665b561ae4edcbf7ef72e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3fbf857117011107c8e7d3c8e82ab89468abddaa74d29b4696cba6338e89b454"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d3cb04de93bf5460c41623c296b5cd81884379d277afc874a64b0ff1cc34ac6a"
    sha256 cellar: :any_skip_relocation, sonoma:         "ef69d2867ef68302e06051ba2cb3d9d883a719f60dec7db49ebbfc36d18ef38a"
    sha256 cellar: :any_skip_relocation, ventura:        "7bd3ad976f084a295edade17403886612453e3b0da624c22a4e1d45496fad5b7"
    sha256 cellar: :any_skip_relocation, monterey:       "b75a6403eff1226c4e348d9766c20694d43388c9ee9afa00fe4f637ab3dd7a9c"
    sha256 cellar: :any_skip_relocation, big_sur:        "695ced76533bfe9a4e893ffe22ea58402dbd93bd180e2ca4b4a96004d5c60581"
    sha256 cellar: :any_skip_relocation, catalina:       "e703b87ff205bfec1cfc09e9c200ebca6be643df15ec99b85c590110a4885fb2"
  end

  depends_on xcode: :build
  depends_on :macos

  def install
    xcodebuild "-project", "SBJson5.xcodeproj",
               "-arch", Hardware::CPU.arch,
               "-target", "sbjson",
               "-configuration", "Release",
               "clean",
               "build",
               "SYMROOT=build"

    bin.install "build/Release/sbjson"
  end

  test do
    (testpath/"in.json").write <<~JSON
      [true,false,"string",42.001e3,[],{}]
    JSON

    (testpath/"unwrapped.json").write <<~JSON
      true
      false
      "string"
      42001
      []
      {}
    JSON

    assert_equal shell_output("cat unwrapped.json"),
                 shell_output("#{bin}/sbjson --unwrap-root in.json")
  end
end

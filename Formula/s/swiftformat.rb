class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.52.7.tar.gz"
  sha256 "c0a84b7a2455b2949d191c696821beddbd0b657ed418a8b4c74e52ae799bf5d6"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5ea12e1d44634889dff5940c9c20f775ea21a4e0e368bf0349200ff717d09764"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "75ec78be0712f8b61a3aa364c510cd7338548dba5c0684778f735a441693ece6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "674754621bdbdb298d54cfbb786a75ec2e497ebd0272278651e52c39925f9043"
    sha256 cellar: :any_skip_relocation, sonoma:         "e430901d81f742be9afcaae64ac3f56f2f95c8c738063492a808795247608078"
    sha256 cellar: :any_skip_relocation, ventura:        "2cecfe76c6b8e250d94e6f75ff48d60a5cb6ef3cd991f659dc4a490e0e41fe3c"
    sha256 cellar: :any_skip_relocation, monterey:       "95bfda22ba1cee55ca196a853b41194afc34138cca7d2d50014e1558ce85fca0"
    sha256                               x86_64_linux:   "09aac5b6f75621820b5d76b6aa4efae8af5e5f5fd18bf051e98d2464376f57b3"
  end

  depends_on xcode: ["10.1", :build]

  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/swiftformat"
  end

  test do
    (testpath/"potato.swift").write <<~EOS
      struct Potato {
        let baked: Bool
      }
    EOS
    system "#{bin}/swiftformat", "#{testpath}/potato.swift"
  end
end

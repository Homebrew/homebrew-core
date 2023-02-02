class Swiftplantuml < Formula
  desc "Generate UML class diagrams from Swift sources"
  homepage "https://github.com/MarcoEidinger/SwiftPlantUML"
  url "https://github.com/MarcoEidinger/SwiftPlantUML/archive/0.7.3.tar.gz"
  sha256 "10cbed4256e8cf0cff8a9b4042b124acba4eb44fbb75fc639d61a1ba2d29c4aa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3cde6194035895f2d9df820f7db9ce70e8500fbf25fa37a593d97f89b68961d8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "35c4349d36a2f2f0cccf561199d6f08b70f2ae72d183279e9d919e5ec2a352dc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d9ea146a22ec555a15256a8adebff3f117d317cbfbce2467cf165dedd8204352"
    sha256 cellar: :any_skip_relocation, ventura:        "44b00f2bb77d5d23b04405ba62d1ed3040b9844ca493c6b84c244d86440a7a17"
    sha256 cellar: :any_skip_relocation, monterey:       "4dc5d7c0ce40fcc805c508cd4947b53c9ee33d34430b22a1b348ed84fc9240c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "77e17a3ee5dba1ca212263dab7fa6223b521bae9e1f62716011957b5b7cf3ba0"
  end

  depends_on xcode: ["12.2", :build]
  depends_on :macos

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/swiftplantuml", "--help"
  end
end

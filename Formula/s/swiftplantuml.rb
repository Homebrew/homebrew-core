class Swiftplantuml < Formula
  desc "Generate UML class diagrams from Swift sources"
  homepage "https://github.com/MarcoEidinger/SwiftPlantUML"
  url "https://github.com/MarcoEidinger/SwiftPlantUML/archive/0.7.6.tar.gz"
  sha256 "d4d57be917fcf86e534877c19c56b0507cf26b7c63e55b5926cf9c6cd5922f8f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "64b7368a338264ea5d909349c6056f1d34be8a32cdfd9fceb2e55bfda11d3a76"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "92f1c20a5e5b57f5a18cb947a6666d348469be9a0db42d41cb99488a3b90e1ab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0771dbc96974de310796084d08048aad85aa27f35ce1f082141ba69acf82a979"
    sha256 cellar: :any_skip_relocation, ventura:        "206547259f05a648df243d6a7713a1762959b5f77e7509c5d21e5f484c6974cd"
    sha256 cellar: :any_skip_relocation, monterey:       "924a8165c2ef5b47bf1ad0afd1ec81cb09ed60d040fba4628f5d8c0d6b3ade58"
    sha256 cellar: :any_skip_relocation, big_sur:        "45b0cef6a4db9677b6ee2e2291167dd99eb665ee7016a9497fa43cb6e96d1e21"
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

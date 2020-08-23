class SwiftSh < Formula
  desc "Scripting with easy zero-conf dependency imports"
  homepage "https://github.com/mxcl/swift-sh"
  url "https://github.com/mxcl/swift-sh/archive/2.0.1.tar.gz"
  sha256 "e31ae29f524c0d8423f34434fda967e36f5f91de1e54e2f4a256f23b94f5a9d9"
  license "Unlicense"
  head "https://github.com/mxcl/swift-sh.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "aeab9b696171e5a0e10896be70317618f096ef5024c2ab73b286a9a958466251" => :catalina
    sha256 "7568e6bb0d39e6ec5582f5e135507fce1cecc3b0ea0706aaa94a8e866a992367" => :mojave
  end

  depends_on xcode: ["11.0", :build]

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/swift-sh"
    bin.install ".build/release/swift-sh-edit"
  end

  test do
    (testpath/"test.swift").write "#!/usr/bin/env swift sh"
    system "#{bin}/swift-sh", "eject", "test.swift"
    assert_predicate testpath/"Test"/"Package.swift", :exist?
  end
end

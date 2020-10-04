class SwiftSh < Formula
  desc "Scripting with easy zero-conf dependency imports"
  homepage "https://github.com/mxcl/swift-sh"
  url "https://github.com/mxcl/swift-sh/archive/2.1.0.tar.gz"
  sha256 "24cd98440bb3c58d244600554e74dccc5734fce1714ee053ae85f872e859c06b"
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

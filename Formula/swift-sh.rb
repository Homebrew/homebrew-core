class SwiftSh < Formula
  desc "Scripting with easy zero-conf dependency imports"
  homepage "https://github.com/mxcl/swift-sh"
  url "https://github.com/mxcl/swift-sh/archive/1.18.0.tar.gz"
  sha256 "e65b43609d43cc9163ef11d4a2b46e9f5f9387a6fd1645ed6ede5aac24333066"
  license "Unlicense"
  head "https://github.com/mxcl/swift-sh.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1859dc05bf66a8849a6722b084d8f226de2db2fcc857f5022f0b03c7d02b8adf" => :catalina
    sha256 "34feeb88ecf77cf68463609411745c465b2338f7d7d7e9f33a988a20f2dcf23e" => :mojave
    sha256 "0339afad23f24918a45036a440dd833c91a0b6ce97d5b6641337d7a851d02c69" => :high_sierra
  end

  depends_on :xcode => ["10.0", :build]

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

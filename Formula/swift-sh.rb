class SwiftSh < Formula
  desc "Scripting with easy zero-conf dependency imports"
  homepage "https://github.com/mxcl/swift-sh"
  url "https://github.com/mxcl/swift-sh/archive/2.2.0.tar.gz"
  sha256 "e3204b3bf727ca27c951080c5eb90b1e193fa8fef0703f60ea068bdb57f39df4"
  license "Unlicense"
  head "https://github.com/mxcl/swift-sh.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f4060ad81c05a41ed20842107a88faa82ab1c7698e5d5f53d6501815b3ece5c9" => :big_sur
    sha256 "4c0584c930b05daa6ec211ad25ef31e591d62822226a555cb6952a586b59895f" => :arm64_big_sur
    sha256 "cb5374c2f8d5fddd23d181f7148b4a5f37ee82b70fd96e2344d58acfef3dbed5" => :catalina
    sha256 "949500fc6f95cb490bcf848b000d7321b4ea0d9e0a67e8e31898c11cec08f1a8" => :mojave
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

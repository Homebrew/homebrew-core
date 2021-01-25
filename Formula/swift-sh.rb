class SwiftSh < Formula
  desc "Scripting with easy zero-conf dependency imports"
  homepage "https://github.com/mxcl/swift-sh"
  url "https://github.com/mxcl/swift-sh/archive/2.2.0.tar.gz"
  sha256 "e3204b3bf727ca27c951080c5eb90b1e193fa8fef0703f60ea068bdb57f39df4"
  license "Unlicense"
  head "https://github.com/mxcl/swift-sh.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9a5f73b88dc332198e97b18c539c0298fbb60690ff61f01735f28c490b12f364" => :big_sur
    sha256 "368220eaccf4e5d1f52f2bb53c6029ba600dd321de54fef4fdfbe6c965c2716b" => :arm64_big_sur
    sha256 "999595646476e2704d01011e10440281c24c638d46bb61eeffad6c9f3d5b4619" => :catalina
    sha256 "3e0f348e5ccb6c22e41e3dc819eb5f8c2228b4874bac5cd24a61a823c97fabad" => :mojave
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

class SwiftSh < Formula
  desc "Scripting with easy zero-conf dependency imports"
  homepage "https://github.com/mxcl/swift-sh"
  url "https://github.com/mxcl/swift-sh/archive/1.17.1.tar.gz"
  sha256 "90c2d8ca708922fdb36b26d81dac768183ff65f0cd00698937fb89435c53dcfb"
  head "https://github.com/mxcl/swift-sh.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "68c8b7cb7f45913c9f88eb0efe967de0d8cfe07031cf74b81034acce58ab2057" => :catalina
    sha256 "7fe23e7ff8ce08c82d6a70f9dc7c1d4acbf5434368b6fbe0fcfcca1b7f10b928" => :mojave
    sha256 "fe8094429de496751358f55f961908072256d586783026ac653395df90b17f5c" => :high_sierra
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

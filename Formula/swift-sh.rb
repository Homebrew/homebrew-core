class SwiftSh < Formula
  desc "Scripting with easy zero-conf dependency imports"
  homepage "https://github.com/mxcl/swift-sh"
  url "https://github.com/mxcl/swift-sh/archive/1.17.0.tar.gz"
  sha256 "6e48fc5697bb19826ecd29ae01167299a5ab1fcece0453fba9318e51020f936d"
  head "https://github.com/mxcl/swift-sh.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "73afb17da0cec32d3aa9e4a1777afe0be7fa8a27689a87f626f9821e10e3e412" => :catalina
    sha256 "75edd9678f6d70c61f1803e10310312b1792ce4e062d5bcbfebf1ec0d8a1b047" => :mojave
    sha256 "75ef921a5ba911ff0304e213bb17ca641ad2769e8b9566015b803e22078ad348" => :high_sierra
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

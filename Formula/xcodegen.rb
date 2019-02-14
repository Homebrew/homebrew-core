class Xcodegen < Formula
  desc "Generate your Xcode project from a spec file and your folder structure"
  homepage "https://github.com/yonaskolb/XcodeGen"
  url "https://github.com/yonaskolb/XcodeGen/archive/2.2.0.tar.gz"
  sha256 "04fcc6b77a354c03b5ce7fff96ea2b55580f79a4dde43132fd9d992436ed01cf"

  bottle do
    cellar :any_skip_relocation
    sha256 "f637cec9a557ec0384351f3ccd566ac4ac81080714c45a6c81c10ac9c95e416a" => :mojave
    sha256 "12d43787af8842f23e27781222f956672c2440e86ccec424947b5d6050881f3e" => :high_sierra
  end

  depends_on :xcode => ["9.3", :build]

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"xcodegen.yml").write <<~EOS
      name: GeneratedProject
      options:
        bundleIdPrefix: com.project
      targets:
        TestProject:
          type: application
          platform: iOS
          sources: TestProject
    EOS
    (testpath/"TestProject").mkpath
    system bin/"XcodeGen", "--spec", testpath/"xcodegen.yml"
    assert_predicate testpath/"GeneratedProject.xcodeproj", :exist?
    assert_predicate testpath/"GeneratedProject.xcodeproj/project.pbxproj", :exist?
    output = (testpath/"GeneratedProject.xcodeproj/project.pbxproj").read
    assert_match "name = TestProject", output
    assert_match "isa = PBXNativeTarget", output
  end
end

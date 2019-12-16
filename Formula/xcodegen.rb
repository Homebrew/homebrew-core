class Xcodegen < Formula
  desc "Generate your Xcode project from a spec file and your folder structure"
  homepage "https://github.com/yonaskolb/XcodeGen"
  url "https://github.com/yonaskolb/XcodeGen/archive/2.11.0.tar.gz"
  sha256 "4e299338c65147283dd9bdda2a8d1ecaaf950f43b11c5b9d28ccd60fbfaff6ef"
  head "https://github.com/yonaskolb/XcodeGen.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2b2feec5d445a91697c79cd7863b9bc53856ccf421f2cf078e9e4f4277a4faa1" => :catalina
    sha256 "d9b119751c32d2c5281a9eaf175f2c49aff398caf5193c3444c6c1b79e03dd16" => :mojave
  end

  depends_on :xcode => ["10.2", :build]

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

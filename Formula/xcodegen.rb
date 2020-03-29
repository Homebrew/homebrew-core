class Xcodegen < Formula
  desc "Generate your Xcode project from a spec file and your folder structure"
  homepage "https://github.com/yonaskolb/XcodeGen"
  url "https://github.com/yonaskolb/XcodeGen/archive/2.14.0.tar.gz"
  sha256 "ceada613a27b2035c817bede007f6b0195cb1d3d39e39d7d89c77202d6ae84fb"
  head "https://github.com/yonaskolb/XcodeGen.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "719bd1987a8a8d93194e882b27b6d84f5e50ae51b9695bcec4cf4d05a472882b" => :catalina
    sha256 "ea1549db98385d013e195d4fb197d54e23476b65617f98d418838cb2188201a7" => :mojave
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

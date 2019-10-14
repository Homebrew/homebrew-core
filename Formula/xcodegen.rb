class Xcodegen < Formula
  desc "Generate your Xcode project from a spec file and your folder structure"
  homepage "https://github.com/yonaskolb/XcodeGen"
  url "https://github.com/yonaskolb/XcodeGen/archive/2.9.0.tar.gz"
  sha256 "d0eee7726fb702ea9f8d64f4bbb02837c5179ecbbb6c0cfd91f0db0c6b874ee3"
  head "https://github.com/yonaskolb/XcodeGen.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4cef79d8c76c381b2104ac4b409c682fe2e2a1dcbb5853ad35693e424adc6917" => :catalina
    sha256 "cd589c0350ba80433e0d578bb44c8a531b3c34dd93477162e2d2fd52dde56e96" => :mojave
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

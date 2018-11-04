class Xcodegen < Formula
  desc "Generate your Xcode project from a spec file and your folder structure"
  homepage "https://github.com/yonaskolb/XcodeGen"
  url "https://github.com/yonaskolb/XcodeGen/archive/2.0.0.tar.gz"
  sha256 "15def1e83368a27c1836b66aa5e80f53513aa045ceb1eabd2480fd7db47f82bf"

  bottle do
    cellar :any_skip_relocation
    sha256 "1126967db861e6161f156bbf08da2619040b2ad85ab8c23040caeebb6a0b2fb7" => :mojave
    sha256 "d8458307465bceeb947b714f865783e2c1268fa8ac704fe50e551a8866fba735" => :high_sierra
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

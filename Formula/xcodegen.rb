class Xcodegen < Formula
  desc "Generate your Xcode project from a spec file and your folder structure"
  homepage "https://github.com/yonaskolb/XcodeGen"
  url "https://github.com/yonaskolb/XcodeGen/archive/2.1.0.tar.gz"
  sha256 "b7895b8daacb7cef19e8dd3518ac060e9d9ba99479aff4a5b6ca44f7326099da"

  bottle do
    cellar :any_skip_relocation
    sha256 "54f33196d44130372f813b734afa3a9a124be465b513a53aab21f0d97784e366" => :mojave
    sha256 "f96423eaaf0d3ccf5cc8a779fc98e6090339d751cc23e1e3b3c5f4e6ec4417bb" => :high_sierra
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

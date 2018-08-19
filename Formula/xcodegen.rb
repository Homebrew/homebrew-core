class Xcodegen < Formula
  desc "Generate your Xcode project from a spec file and your folder structure"
  homepage "https://github.com/yonaskolb/XcodeGen"
  url "https://github.com/yonaskolb/XcodeGen/archive/1.11.0.tar.gz"
  sha256 "f1fbfe042183898251bd5ec391efe143e83e307a5a3468cec8ca9145c50e9a62"

  bottle do
    cellar :any_skip_relocation
    sha256 "029b14f3ba4b1971f530b59375abd85161fc4fc46d7e615d9dcddc4d98e6b638" => :high_sierra
  end

  depends_on :xcode => ["9.3", :build]

  def install
    # fixes an issue an issue in homebrew when both Xcode 9.3+ and command line tools are installed
    # see more details here https://github.com/Homebrew/brew/pull/4147
    # remove this once homebrew is patched
    ENV["CC"] = Utils.popen_read("xcrun -find clang").chomp

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

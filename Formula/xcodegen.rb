class Xcodegen < Formula
  desc "Generate your Xcode project from a spec file and your folder structure"
  homepage "https://github.com/yonaskolb/XcodeGen"
  url "https://github.com/yonaskolb/XcodeGen/archive/2.29.0.tar.gz"
  sha256 "d00d98e0f005ce581bcd354c057d29a08f37ad28c9e81cfe4f26d11d8770371b"
  license "MIT"
  head "https://github.com/yonaskolb/XcodeGen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f76deffe6ad019b5004774c27175af44d1e2a17f2bb932e3053c43338f4dc9e2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1dfbd86106c388ca72308a0b96f02140030767279bb2c1789e4e8d8f8aac0437"
    sha256 cellar: :any_skip_relocation, monterey:       "b1aeb953a94bd3bf0e32365c9f7eb52e75d4340f2ff2e2298ae6a822f87b12b7"
    sha256 cellar: :any_skip_relocation, big_sur:        "f5032654ab7d638460ff819699fc5822039482e307c3f68dcb31146106b98ef8"
    sha256 cellar: :any_skip_relocation, catalina:       "9b7a3ab693384e83bed188f1bef6b7bf1bca6025affb9d9890aecf7973552b12"
  end

  depends_on xcode: ["10.2", :build]
  depends_on :macos

  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/#{name}"
    pkgshare.install "SettingPresets"
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
    system bin/"xcodegen", "--spec", testpath/"xcodegen.yml"
    assert_predicate testpath/"GeneratedProject.xcodeproj", :exist?
    assert_predicate testpath/"GeneratedProject.xcodeproj/project.pbxproj", :exist?
    output = (testpath/"GeneratedProject.xcodeproj/project.pbxproj").read
    assert_match "name = TestProject", output
    assert_match "isa = PBXNativeTarget", output
  end
end

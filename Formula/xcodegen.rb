class Xcodegen < Formula
  desc "Generate your Xcode project from a spec file and your folder structure"
  homepage "https://github.com/yonaskolb/XcodeGen"
  url "https://github.com/yonaskolb/XcodeGen/archive/2.29.0.tar.gz"
  sha256 "d00d98e0f005ce581bcd354c057d29a08f37ad28c9e81cfe4f26d11d8770371b"
  license "MIT"
  head "https://github.com/yonaskolb/XcodeGen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa493f26e65f0bb0c6be559a395efb84009d842d55035c8fcfd7bcc35096fd17"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "54ce7cba17293f6eabd644af8c8855ca5ac46f4e8475e5a1a961053d31061210"
    sha256 cellar: :any_skip_relocation, monterey:       "261df12ea22b281c6683113755a95887213aec51a345851d3671eec6a82dd169"
    sha256 cellar: :any_skip_relocation, big_sur:        "24936b2f648842c026cc0da57ac4d2a04669a1bd459af06d20acfbfa3a1c33da"
    sha256 cellar: :any_skip_relocation, catalina:       "d7b4298a5833f5c2abaa8f19cd60f1da2f13379b9534d67746ac5a37b754e1bd"
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

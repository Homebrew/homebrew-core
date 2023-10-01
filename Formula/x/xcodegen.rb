class Xcodegen < Formula
  desc "Generate your Xcode project from a spec file and your folder structure"
  homepage "https://github.com/yonaskolb/XcodeGen"
  url "https://github.com/yonaskolb/XcodeGen/archive/2.37.0.tar.gz"
  sha256 "3eb78c0bbaa3342f2bcd3781571c70937e8c51b962c5aebeea1390f56fabd3c8"
  license "MIT"
  head "https://github.com/yonaskolb/XcodeGen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "01a6e074defcf2b17bb25bdc28daf96bbfd9aaea65f40c4f31b34178e04a2477"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d147d0bbde8f76fe1c88da308c1f99e866d1702458e82b685a164505de10093"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9058c7b14f8ea6e8457c808db3329eb0b2f7aa3de00d147e931501dcc2e26874"
    sha256 cellar: :any_skip_relocation, sonoma:         "162c4534eb6bfcf41d8b0447830001fd08d9d38aa4151aa62eee66858b4ddc55"
    sha256 cellar: :any_skip_relocation, ventura:        "caddccdd2b82aef7ae9221d1249b0af14bf5c4befe8ceb5445d55a9150649ed6"
    sha256 cellar: :any_skip_relocation, monterey:       "54fefbac5d69356b64354c1e7b281feeee2ae27ee79cf34505a0e23a3d2196a9"
  end

  depends_on xcode: ["14.0", :build]
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

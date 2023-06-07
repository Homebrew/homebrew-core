class Xcodegen < Formula
  desc "Generate your Xcode project from a spec file and your folder structure"
  homepage "https://github.com/yonaskolb/XcodeGen"
  url "https://github.com/yonaskolb/XcodeGen/archive/2.35.0.tar.gz"
  sha256 "cb1145b1a0de043d0e64ff97a9c7886051b3e9104d4df4d6ad132a4ef8ab7c92"
  license "MIT"
  head "https://github.com/yonaskolb/XcodeGen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ca9aa5cf7c7a4573bd3ff2c1afbe871566e57478c09967abca7585fc1c237470"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dadb3716295017a392da394eb0bb52360d95e9142e21ac5532e1d29def593ad6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6026a0e84873586f7e65584bd3e9a9456f4b590c2498ebf986e563d66bccb3a7"
    sha256 cellar: :any_skip_relocation, ventura:        "bb982470aad36dececfab94449696b1a327ea931b61475832fd41c5fa59ebb60"
    sha256 cellar: :any_skip_relocation, monterey:       "366403595292790a4a84e2db6f0f32c14fa907c77ac424a5e24d431d372e7a17"
    sha256 cellar: :any_skip_relocation, big_sur:        "6db46a3673d4cd395cabd22bbe28e701eef7eaa4f198829fd8a4df072eb9a6ff"
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

class Xcodegen < Formula
  desc "Generate your Xcode project from a spec file and your folder structure"
  homepage "https://github.com/yonaskolb/XcodeGen"
  url "https://github.com/yonaskolb/XcodeGen/archive/refs/tags/2.44.1.tar.gz"
  sha256 "995e2251345d9cef46a027351a3b86a92ceea81702449eb03e1aafa45869133d"
  license "MIT"
  head "https://github.com/yonaskolb/XcodeGen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "50d0730465d1f56f1ab931ba18e213b2d906a4bc16024fc697f32a8e28249fbe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "840226c324d2dccfd94794908bf80e34afbfdce0a014e69b4cefd42671f310a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb57b2b779fdab389d7c8975749bbaab6cecd75227b8bd45d6c6f8121b953fd6"
    sha256 cellar: :any_skip_relocation, sonoma:        "02995cc931f1364127444756c9a34c75ca3f1d7a6e949ab6a1b3c44fe057e981"
  end

  depends_on xcode: ["15.3", :build]
  depends_on :macos

  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/#{name}"
    pkgshare.install "SettingPresets"
  end

  test do
    (testpath/"xcodegen.yml").write <<~YAML
      name: GeneratedProject
      options:
        bundleIdPrefix: com.project
      targets:
        TestProject:
          type: application
          platform: iOS
          sources: TestProject
    YAML
    (testpath/"TestProject").mkpath
    system bin/"xcodegen", "--spec", testpath/"xcodegen.yml"
    assert_path_exists testpath/"GeneratedProject.xcodeproj"
    assert_path_exists testpath/"GeneratedProject.xcodeproj/project.pbxproj"
    output = (testpath/"GeneratedProject.xcodeproj/project.pbxproj").read
    assert_match "name = TestProject", output
    assert_match "isa = PBXNativeTarget", output
  end
end

class Xcodegen < Formula
  desc "Generate your Xcode project from a spec file and your folder structure"
  homepage "https://github.com/yonaskolb/XcodeGen"
  url "https://github.com/yonaskolb/XcodeGen/archive/refs/tags/2.45.4.tar.gz"
  sha256 "90705e5c410a980f7d98f75462bba2120de7c94b721cc06fd3f7e52a52a1aeed"
  license "MIT"
  head "https://github.com/yonaskolb/XcodeGen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f8763683b5538a556ac4de3a86132558a086fdd976ac4088ff87d09fae1982b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8434a5e2b5d1c6495a7e09dd14ef86050fde9013962783f693c1577df4dbca94"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d15c5e057291079c9d2fb2aeb18a0fa15605bfc9223a8ab36d4a7f77e6c0104"
    sha256 cellar: :any_skip_relocation, sonoma:        "372bc6322e8df098d6427ddc89fd6c12bd1e14ef62593b1f3573776e99608a1e"
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

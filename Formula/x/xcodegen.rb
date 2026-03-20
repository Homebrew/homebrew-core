class Xcodegen < Formula
  desc "Generate your Xcode project from a spec file and your folder structure"
  homepage "https://github.com/yonaskolb/XcodeGen"
  url "https://github.com/yonaskolb/XcodeGen/archive/refs/tags/2.45.3.tar.gz"
  sha256 "b8df8b3cffc65621838133fcc168afe4f444dbe9dc74cd32d1445d93380b4389"
  license "MIT"
  head "https://github.com/yonaskolb/XcodeGen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d6d74e8fa238c41653e0149561f31902fd2381b6f2299508dc9eaf74afd10a9b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c725804686c82bfa237d841e89a845306791c42c1a7e81de936953975311c96"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc1bec985217dd2d69db5cedc89d465d5de0bc9593a9d47503c5d84370e83761"
    sha256 cellar: :any_skip_relocation, sonoma:        "db8e32720ad4d57a749fc0b2262240f280beb102021d5abbcb8022cdb199b6a1"
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

class Xcodegen < Formula
  desc "Generate your Xcode project from a spec file and your folder structure"
  homepage "https://github.com/yonaskolb/XcodeGen"
  url "https://github.com/yonaskolb/XcodeGen/archive/refs/tags/2.46.0.tar.gz"
  sha256 "c83c7bd70255b0ddf4116dadce16bdf0e5939165b43a544e124de294ec84aa27"
  license "MIT"
  head "https://github.com/yonaskolb/XcodeGen.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "69a3584c1c9118cd37e45565b8679e1c84663e783e720c68e85ef6000a52c870"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f06608766b94ca4ca5eb380ff38abfa908015f05c7f0eef41f22ac2a97c4288"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e23b1e8501ad0276d810f41d195ad30787e55634e845c039d4ce015491455dba"
    sha256 cellar: :any_skip_relocation, sonoma:        "d0e021076a96894c2d48a51003e99ab4885130f69ea922a67de8bef3062c5a50"
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

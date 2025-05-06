class Xcodegen < Formula
  desc "Generate your Xcode project from a spec file and your folder structure"
  homepage "https://github.com/yonaskolb/XcodeGen"
  url "https://github.com/yonaskolb/XcodeGen/archive/refs/tags/2.43.0.tar.gz"
  sha256 "d79a89ea056ccc3cf84b736ee52c7b5184a560e54808e51f418f34d292869d66"
  license "MIT"
  head "https://github.com/yonaskolb/XcodeGen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d08e16ea70ce5f323dd53197ed1204c6a78be04e629bb8e8cd11329b5d13c5d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b52935ffdb916dcfa90efef93419cbc050764f0d29e139ef951b8b994ee492c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "db60cd9e7757912208a1ba128f1652f9dd49beac21d7b83bfd9d16d59bc6241f"
    sha256 cellar: :any_skip_relocation, sonoma:        "58ca67427dc960bc75413e651a476926eeed167e10dec790dfd16d560334fa70"
    sha256 cellar: :any_skip_relocation, ventura:       "6efa069b3f9ade5e77b7d0dd1fa76b3dae8d3914d45a3da5ff48a8e79e3a5f75"
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

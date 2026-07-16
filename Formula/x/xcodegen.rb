class Xcodegen < Formula
  desc "Generate your Xcode project from a spec file and your folder structure"
  homepage "https://github.com/yonaskolb/XcodeGen"
  url "https://github.com/yonaskolb/XcodeGen/archive/refs/tags/2.46.0.tar.gz"
  sha256 "c83c7bd70255b0ddf4116dadce16bdf0e5939165b43a544e124de294ec84aa27"
  license "MIT"
  head "https://github.com/yonaskolb/XcodeGen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a8ff378ca37e4ab1a156fcbe92969b494d2cb8f5baac5e495f68b2d60f5ddac0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ebea523cb8607c27760b94b8cf20676eefc3f63b5a1feb4de60f13d73928680a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a08243b1e0d862b0510041beedba96034861f484c5bc173b96f09fcc83e9de48"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca21a5522a0fc3afe039f3720067afe0191fae810418c1f84a3ac2034349ca6d"
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

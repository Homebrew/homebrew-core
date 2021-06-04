class Xcodegen < Formula
  desc "Generate your Xcode project from a spec file and your folder structure"
  homepage "https://github.com/yonaskolb/XcodeGen"
  url "https://github.com/yonaskolb/XcodeGen/archive/2.23.1.tar.gz"
  sha256 "2e3ac42ee84f5d9ad5de747a0b8cee8dca5b6ed10e730792e604f51611fba8ee"
  license "MIT"
  head "https://github.com/yonaskolb/XcodeGen.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b0b59288841ec7f9d3e2bccf4b997fc64ecf780e07ebbdff540c479a5646f3e5"
    sha256 cellar: :any_skip_relocation, big_sur:       "8ad14d7fb0e16a96a25266012b78bfd2d7d4abca852a35cc0435bf1aa17d098a"
    sha256 cellar: :any_skip_relocation, catalina:      "89262c01ee3e925144a74eb15daabb46875e1c2c54514cf8acc3ab62c14c97b6"
  end

  depends_on xcode: ["10.2", :build]
  depends_on macos: :catalina

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
    system bin/"XcodeGen", "--spec", testpath/"xcodegen.yml"
    assert_predicate testpath/"GeneratedProject.xcodeproj", :exist?
    assert_predicate testpath/"GeneratedProject.xcodeproj/project.pbxproj", :exist?
    output = (testpath/"GeneratedProject.xcodeproj/project.pbxproj").read
    assert_match "name = TestProject", output
    assert_match "isa = PBXNativeTarget", output
  end
end

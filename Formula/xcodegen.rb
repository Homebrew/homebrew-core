class Xcodegen < Formula
  desc "Generate your Xcode project from a spec file and your folder structure"
  homepage "https://github.com/yonaskolb/XcodeGen"
  url "https://github.com/yonaskolb/XcodeGen/archive/2.34.0.tar.gz"
  sha256 "35ae2fe205fb2505e217b854d2b8778bcb5d6035e6f19cafa0b1ab95f2e2c74a"
  license "MIT"
  head "https://github.com/yonaskolb/XcodeGen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "76d47e558129e02cb16dbcdbb92b25ac5ab47658f4736cd1f68d205bebcd0001"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "092164ce460d49adbc33023f55ec6b9a5704d787e18c05ac7d62232c47bdc91e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b4ba5b91c37a2b3b364a5af35d207eac215a2c00987d008a3002a9d643d39652"
    sha256 cellar: :any_skip_relocation, ventura:        "38a9e261286f6f7e402eef108a6b0fc02884a9872d9464d69a56b1adc725c7fe"
    sha256 cellar: :any_skip_relocation, monterey:       "a05217b82deaa2efa0ee832b663232aab66aabe2d2c08ad2e3fde723b6faffb0"
    sha256 cellar: :any_skip_relocation, big_sur:        "f5b9313d25bff493ea073b291c2a86d3633cc16ec331fa3d2caf8a1131247bbb"
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

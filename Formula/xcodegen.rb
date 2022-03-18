class Xcodegen < Formula
  desc "Generate your Xcode project from a spec file and your folder structure"
  homepage "https://github.com/yonaskolb/XcodeGen"
  url "https://github.com/yonaskolb/XcodeGen/archive/2.26.0.tar.gz"
  sha256 "10cca149699e358bef410a12cafd496b0838008a9accb422ffe00608f861f24a"
  license "MIT"
  head "https://github.com/yonaskolb/XcodeGen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "67808f91003859ba6c2e93cdab598aa2badd8880468e4035823c7dff355bc7a3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "572be1ef81ff8fc5d4548d606e9bcc4549f52cb25cda9f596bdbcce706aafe2a"
    sha256 cellar: :any_skip_relocation, monterey:       "cecf4c25ddcf696c4b63027d5d21278b5a3a550bcb1d6b11911b9c3c4dd2c630"
    sha256 cellar: :any_skip_relocation, big_sur:        "12c836f28b0635f710cdf4aef0be0ab957ee22fde9bafbd4f1c68dd4ce683f32"
    sha256 cellar: :any_skip_relocation, catalina:       "a845d879aba3867a72047665e5a598556aa3745bb2f25e038e357a66e23a1b89"
    sha256                               x86_64_linux:   "271a58fa570b85837819ed241b5e35736f2bb4b2ae5b8c03fa78f4afd540fda6"
  end

  depends_on xcode: ["10.2", :build]
  depends_on macos: :catalina

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

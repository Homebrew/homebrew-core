class Xcodegen < Formula
  desc "Generate your Xcode project from a spec file and your folder structure"
  homepage "https://github.com/yonaskolb/XcodeGen"
  url "https://github.com/yonaskolb/XcodeGen/archive/2.31.0.tar.gz"
  sha256 "df8b44a03c3c79122d87c179fa8d6b86314b7a8882ba02c7773d7a04120da565"
  license "MIT"
  head "https://github.com/yonaskolb/XcodeGen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e8611e4ecda09e4ff15dd8224944c73e16088fa5de064fba01bdd32d729a244b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "43e4e6961448b8fb6a48be442c6123c89ba1a1ce6e4706344f0ac3a8f7707d91"
    sha256 cellar: :any_skip_relocation, monterey:       "c11558faf38525b6d0614cb4adaa87bf0c09c7cea9d25dc68939387ff4468d65"
    sha256 cellar: :any_skip_relocation, big_sur:        "622c23eb754076cfc2579fa3bf586473e771911f6b5b0d0a691ae4504dd14e1c"
    sha256 cellar: :any_skip_relocation, catalina:       "75c701ed28569be322e69d0c9c125d49550a16c5495f38d7fab5ba90a555803d"
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

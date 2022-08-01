class Xcodegen < Formula
  desc "Generate your Xcode project from a spec file and your folder structure"
  homepage "https://github.com/yonaskolb/XcodeGen"
  url "https://github.com/yonaskolb/XcodeGen/archive/2.31.0.tar.gz"
  sha256 "df8b44a03c3c79122d87c179fa8d6b86314b7a8882ba02c7773d7a04120da565"
  license "MIT"
  head "https://github.com/yonaskolb/XcodeGen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c0d59b3c9c2b8bd8b847895341494783a64fc6e883219fb9c5f42e66e883e7a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4c776a7bca4b8221318f658441f7c5528dda2c91f6e58f66f6dba11c78f02671"
    sha256 cellar: :any_skip_relocation, monterey:       "80b230d284ef71667ccf98d4ca25ef246049e38986e03daf0926a14e51f52f08"
    sha256 cellar: :any_skip_relocation, big_sur:        "88c179e5e29319e89782b18dfadeddb1237005163904dd08477559b2e306b95d"
    sha256 cellar: :any_skip_relocation, catalina:       "0d96563eaf9badacd9ce1d0c6fc9445d88bd33017a8ad4259da8552020207140"
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

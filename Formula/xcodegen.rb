class Xcodegen < Formula
  desc "Generate your Xcode project from a spec file and your folder structure"
  homepage "https://github.com/yonaskolb/XcodeGen"
  url "https://github.com/yonaskolb/XcodeGen/archive/2.25.0.tar.gz"
  sha256 "bae6b1b59ac2c43e9efc3b789fcfb0e093fa9d0b3d1e3b654735a5cba3d0019c"
  license "MIT"
  head "https://github.com/yonaskolb/XcodeGen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c75414fd0917557984b1f4157ffa8b604c41c3de094e503e68500e877917a4a8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "558d80be972d11ef397faf078060b06eec90a8c0e8371202ec5691660c27c3af"
    sha256 cellar: :any_skip_relocation, monterey:       "45edd1789a68c07909c29dad1eb25cda02a8fe50e5d44e62660949170c84964d"
    sha256 cellar: :any_skip_relocation, big_sur:        "88f2036496a41621c151480d5841a7f7bed90157a292e7cd48efb121a082a29b"
    sha256 cellar: :any_skip_relocation, catalina:       "366ce43fa5f03f0fa975bb4f1433b4aa8a8ba3a745148cf4800b7e25266aa800"
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

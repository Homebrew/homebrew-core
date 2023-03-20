class Xcodegen < Formula
  desc "Generate your Xcode project from a spec file and your folder structure"
  homepage "https://github.com/yonaskolb/XcodeGen"
  url "https://github.com/yonaskolb/XcodeGen/archive/2.34.0.tar.gz"
  sha256 "35ae2fe205fb2505e217b854d2b8778bcb5d6035e6f19cafa0b1ab95f2e2c74a"
  license "MIT"
  head "https://github.com/yonaskolb/XcodeGen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "30a9c593d0d156e7a0b0733a36bd9ed9d8b122d92f535f5de57e955d72b063f1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5cfb54c7c4ca5e7e4b754d147f3b4f9b508a896b54de08c06a1ea9100926456d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aec3bd05fa69ce9b301f2758c2fa42a37e670474d691cf7fe537aaff71c35100"
    sha256 cellar: :any_skip_relocation, ventura:        "1106db445e164d03888b496b2f3ebacd442df2a1bb7a3ad575958d5a3064eb9d"
    sha256 cellar: :any_skip_relocation, monterey:       "6dd5d8674e0af610acaf1fab726bb26091adb49969a30ef8fbc5da91fbe46dba"
    sha256 cellar: :any_skip_relocation, big_sur:        "b4834f7117abca2bcbae00702af72ebd553129ea0c993ce97d44a742420c8ff3"
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

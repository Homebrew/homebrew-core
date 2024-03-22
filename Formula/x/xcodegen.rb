class Xcodegen < Formula
  desc "Generate your Xcode project from a spec file and your folder structure"
  homepage "https://github.com/yonaskolb/XcodeGen"
  url "https://github.com/yonaskolb/XcodeGen/archive/refs/tags/2.39.1.tar.gz"
  sha256 "6ac9208d9bc777790f917d67ea8019631f67204179478a81eb21e9847a650dc6"
  license "MIT"
  head "https://github.com/yonaskolb/XcodeGen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "920fa6538d8abdc1baf1e831e5f3577f14c4a23e64a8da79e64afc931b6447cd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aeb51bd068d90ccd72734af6c5e3a800429a8d0966d49cb898e82e4684191c72"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc0ed0999561d9508394c438ceb2edc74be21a5ea0197902cda59f203459216a"
    sha256 cellar: :any_skip_relocation, sonoma:         "98f8ec64249e75a66ea273db761bdbdf964f65af060d580a6e31f51afa2a733b"
    sha256 cellar: :any_skip_relocation, ventura:        "f7af86b796621f18ff648ac259ba1412b884cf5ab6827369946bc5e70163cac4"
    sha256 cellar: :any_skip_relocation, monterey:       "3e7365278fd9dbc2fe942c50fc704268c8152b9771d05d691d952f448883633f"
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

class Xcodegen < Formula
  desc "Generate your Xcode project from a spec file and your folder structure"
  homepage "https://github.com/yonaskolb/XcodeGen"
  url "https://github.com/yonaskolb/XcodeGen/archive/refs/tags/2.38.0.tar.gz"
  sha256 "8dc9757feb532c7b2ce71184048776a8ebab8ef07677779f2a5c537a80abf30e"
  license "MIT"
  head "https://github.com/yonaskolb/XcodeGen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "422fb8dfbc7e2ed59125d22b4687bb54a1ab3f0ddef044a3875b624121f9be47"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5b2d9dfdf8bc9912ecef48ecc4a03cfb4ba68f35f03c4ab4fc9e893b077f8796"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a239feca86c46f78ae91d631858d957cb2e7e63ea7230b30f3d618097774bff"
    sha256 cellar: :any_skip_relocation, sonoma:         "346164300a7e835f8516c70b25793702bab2437d7e9fb606b5394ab757dab4f5"
    sha256 cellar: :any_skip_relocation, ventura:        "2bca799f6fee1e679a3f826a9a977449a23f81f02896b22a525056f6cd4a07dd"
    sha256 cellar: :any_skip_relocation, monterey:       "3e306a4b9ad078c77b61d93090c224304c7dac35ca119808db87792edb983be8"
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

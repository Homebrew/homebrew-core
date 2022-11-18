class Xcodegen < Formula
  desc "Generate your Xcode project from a spec file and your folder structure"
  homepage "https://github.com/yonaskolb/XcodeGen"
  url "https://github.com/yonaskolb/XcodeGen/archive/2.32.0.tar.gz"
  sha256 "dbf6c1af134a8db4d19f11065ef4502cfe4c4b1fe488d7bf5993e56a1d545775"
  license "MIT"
  head "https://github.com/yonaskolb/XcodeGen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd35de6f71508052f8ccac6d2198150822c9b0c28d662e7b543f3d539cae336b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "22d97109850126936386bc38a22459d9e8ac3ba1e00b254f5149e954f543c2ec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ab30a37ef8e3c885b1cd05c30a844612237f52308556256cb4698784d00a2ad4"
    sha256 cellar: :any_skip_relocation, ventura:        "7fccacda022483fab4c0c38c8c1b60c3ac7d263bc91ccf76169d58b0de8728e0"
    sha256 cellar: :any_skip_relocation, monterey:       "6ef4431936bc868e8026c9ddb8396fa5ac2d9d53a611a59b23fc081d3a5ad0bb"
    sha256 cellar: :any_skip_relocation, big_sur:        "4c990bf05734cbb192171079d69e996837092603985c41904ddec799aa51fcbe"
    sha256 cellar: :any_skip_relocation, catalina:       "330bf63ef11b30bde8f32aea2d46604fd16bcfcff1b918ab95fe294ea9f3708a"
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

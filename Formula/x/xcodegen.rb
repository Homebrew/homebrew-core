class Xcodegen < Formula
  desc "Generate your Xcode project from a spec file and your folder structure"
  homepage "https://github.com/yonaskolb/XcodeGen"
  url "https://github.com/yonaskolb/XcodeGen/archive/refs/tags/2.41.0.tar.gz"
  sha256 "d7588e490ea636cc4eabd08b6f63167c1497a5d579b692fc02e8b1e39636810c"
  license "MIT"
  head "https://github.com/yonaskolb/XcodeGen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b2f1f39d64fa407a269f54b52c0a0f0146f969acf33c249ff26f7f7fdfcd0a28"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "13fe8b46f335606f2569ed269af0b16986d44d09e78fa3fa2bc79339dc809492"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3e4f9b035dab501b000b557be1f40f5598b92b9d24f9f99f85189e5efe26567"
    sha256 cellar: :any_skip_relocation, sonoma:         "a11570c25c391c042aad334be4e664991cd85dc071f17f5d87dae5452259c022"
    sha256 cellar: :any_skip_relocation, ventura:        "6c9b0543e5e4e974f90b1c90fdd93c6cefeb83d85916265fdc258afd5cbcc519"
    sha256 cellar: :any_skip_relocation, monterey:       "48f620563441f0b0a99ec8809a1a2809b26d03a51e3615083a2b4b1e5ff2c36b"
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

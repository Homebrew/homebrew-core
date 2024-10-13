class Xcodegen < Formula
  desc "Generate your Xcode project from a spec file and your folder structure"
  homepage "https://github.com/yonaskolb/XcodeGen"
  url "https://github.com/yonaskolb/XcodeGen/archive/refs/tags/2.42.0.tar.gz"
  sha256 "0cdb0f651c8d211d597237a91b510740558cbe32a4ae66921b00ab5e712a5b83"
  license "MIT"
  head "https://github.com/yonaskolb/XcodeGen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "133251357e73214796c570f3ae83a172265811b095072a763fdbe666444599b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4f381301ea4342d10902c1c32590174f1cb47eef5d39ee2084890aa7706ad7db"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "43d8b5908054352f54ea573d7fdb913c5a5d2727d234aad46a0e5f1d464e59b5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ce790bad53805fb0a9a1765b956ca1285d127ee88433a75817052e7c50c1845"
    sha256 cellar: :any_skip_relocation, sonoma:         "752bf743bc5fc19accf9ac9ef25d0eadecdfeab82f96dd52858600553435c39e"
    sha256 cellar: :any_skip_relocation, ventura:        "dd293952eaf411eb304d06943344b07ffd0235299775dcbcb02740b5a19222f8"
    sha256 cellar: :any_skip_relocation, monterey:       "e186ccdf92bc69f5d4e073e3c256be9833ff3b3788fd1f05b8d942ca98926081"
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

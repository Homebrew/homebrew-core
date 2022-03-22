class Xcodegen < Formula
  desc "Generate your Xcode project from a spec file and your folder structure"
  homepage "https://github.com/yonaskolb/XcodeGen"
  url "https://github.com/yonaskolb/XcodeGen/archive/2.27.0.tar.gz"
  sha256 "76de91cac0ab00a3f1212ba2ee2255a6c78b3c5becabc13ada5a04ef69465ffe"
  license "MIT"
  head "https://github.com/yonaskolb/XcodeGen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "968f228a77d3a25b66fbd8effe034f92837165a62a1ec5932814f0ac91ccd861"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b703c29270c3600c475b8ad97814c37350f84a6a6243535bcc26af1b8b6127c1"
    sha256 cellar: :any_skip_relocation, monterey:       "bf7da2d2159851bd8ea79c24c25fecae520e7ac52f4bf7eee6f40aed2d6ed29b"
    sha256 cellar: :any_skip_relocation, big_sur:        "b523b46556ef3f6d1912982cde443fe354dc0360148bacaa3c4aa9e0940eb4d6"
    sha256 cellar: :any_skip_relocation, catalina:       "d6dc0185ffc184dd29c923bcaeb291332f0df5eb87d057d4715d6617449ce47a"
    sha256                               x86_64_linux:   "8360eb78ec5a2fcfebbba9d32acbe24177675b2f69142a98832d3ccaacdc6519"
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

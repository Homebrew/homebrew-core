class Xcodegen < Formula
  desc "Generate your Xcode project from a spec file and your folder structure"
  homepage "https://github.com/yonaskolb/XcodeGen"
  url "https://github.com/yonaskolb/XcodeGen/archive/refs/tags/2.40.1.tar.gz"
  sha256 "b9e6233a32819bf83d17f49d014610703f0fd5170b510f527bf4779aecc86d0b"
  license "MIT"
  head "https://github.com/yonaskolb/XcodeGen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "97ef2bd7b87e9bbe2fea19d075453a2e00c8514fe6ed359a109153f87518c0dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "01ae513fb69bac9e8d43ca2d811fb9a55a332a3b61b584bb4938283114e912de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf8e788bd89f036e9b96103cb0e687bda487f72bff0f9f2ff4d2a3ebeb889e01"
    sha256 cellar: :any_skip_relocation, sonoma:         "65ec3152dae81228b5cf4aefd85743277d755cf3036b6822c5395d53e1e4137c"
    sha256 cellar: :any_skip_relocation, ventura:        "02ca0a9a4947ab51dcc400f48f0ca12e0e18788954c4dadd8c6b6376534d55a4"
    sha256 cellar: :any_skip_relocation, monterey:       "5b8a174ea297454f4aa1f26753e361f7c051ee73a2b4b1529e999dac090edf24"
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

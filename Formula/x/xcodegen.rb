class Xcodegen < Formula
  desc "Generate your Xcode project from a spec file and your folder structure"
  homepage "https://github.com/yonaskolb/XcodeGen"
  url "https://github.com/yonaskolb/XcodeGen/archive/refs/tags/2.49.0.tar.gz"
  sha256 "2a94567303c5ff9a21b91c9af21ea51c681b012cfbf0d2852fb567865b310fe4"
  license "MIT"
  compatibility_version 1
  head "https://github.com/yonaskolb/XcodeGen.git", branch: "master"

  bottle do
    manifest_sha256 "51eb3836846f11aabdb09b069fdd428d9fb7269a50376da2712a54c1410d8eca"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "152837535a99288aca640010d35485374fb24827123d683524f6b5316c3d7096"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a9f2b5fe6ce80e5d03b9dac388323c2830349fd209e4e38d453f87697613ddc2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "340bb75318c9ee470eadaaba9bbd7f55020e77946b1990dec54395f75a8b6929"
  end

  depends_on xcode: ["15.3", :build]
  depends_on :macos

  uses_from_macos "swift"

  deny_network_access!

  def fetch
    # SwiftPM tries to apply its own sandbox, which cannot nest inside the
    # build sandbox; Homebrew's sandbox still confines the whole process.
    system "swift", "package", "resolve", "--disable-sandbox"
  end

  def install
    system "swift", "build", *std_swift_args
    bin.install ".build/release/#{name}"
    pkgshare.install "SettingPresets"
  end

  test do
    (testpath/"xcodegen.yml").write <<~YAML
      name: GeneratedProject
      options:
        bundleIdPrefix: com.project
      targets:
        TestProject:
          type: application
          platform: iOS
          sources: TestProject
    YAML
    (testpath/"TestProject").mkpath
    system bin/"xcodegen", "--spec", testpath/"xcodegen.yml"
    assert_path_exists testpath/"GeneratedProject.xcodeproj"
    assert_path_exists testpath/"GeneratedProject.xcodeproj/project.pbxproj"
    output = (testpath/"GeneratedProject.xcodeproj/project.pbxproj").read
    assert_match "name = TestProject", output
    assert_match "isa = PBXNativeTarget", output
  end
end

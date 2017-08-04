class Xcodegen < Formula
  desc "Tool that generates your Xcode project from a project spec"
  homepage "https://github.com/yonaskolb/XcodeGen"
  url "https://github.com/yonaskolb/XcodeGen/archive/0.3.0.tar.gz"
  sha256 "f84b14309807909bae1a64f026a7e6e768ca9234b7f0865f05cbbdd606f7528d"
  head "https://github.com/yonaskolb/XcodeGen.git"

  depends_on :xcode

  def install
    yaml_lib_path = "#{buildpath}/.build/release/libCYaml.dylib"
    xcodegen_path = "#{buildpath}/.build/release/XcodeGen"
    ohai "Building XcodeGen"
    system("swift build -c release -Xlinker -rpath -Xlinker @executable_path -Xswiftc -static-stdlib")
    system("install_name_tool -change #{yaml_lib_path} #{frameworks}/libCYaml.dylib #{xcodegen_path}")
    frameworks.install yaml_lib_path
    bin.install xcodegen_path
  end

  test do
    (testpath/"xcodegen.yml").write <<-EOS.undent
      name: GeneratedProject
      targets:
        - name: TestProject
          type: application
          platform: iOS
          sources: TestProject
          settings:
            PRODUCT_BUNDLE_IDENTIFIER: com.test
            PRODUCT_NAME: TestProject
          scheme:
            configVariants
    EOS
    Dir.mkdir(File.join(testpath, "TestProject"))
    system("#{bin}/XcodeGen --spec #{File.join(testpath, "xcodegen.yml")}")
    system("xcodebuild -project #{File.join(testpath, "GeneratedProject.xcodeproj")}")
  end
end

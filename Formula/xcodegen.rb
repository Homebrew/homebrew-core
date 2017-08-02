require "English"

class Xcodegen < Formula
  desc "Tool that generates your Xcode project from a project spec."
  homepage "https://github.com/yonaskolb/XcodeGen"
  url "https://github.com/yonaskolb/XcodeGen/archive/#{version}.tar.gz"
  version "0.1"
  sha256 "29338d4fb17160408fc781e01143b3eff3dc4dc8db8305ef04864dea9e11bb62"
  head "https://github.com/yonaskolb/XcodeGen.git"

  depends_on :xcode

  def install
    yaml_lib_path = "#{buildpath}/.build/release/libCYaml.dylib"
    xcodegen_path = "#{buildpath}/.build/release/XcodeGen"
    ohai "Building XcodeGen"
    system("swift build -c release -Xlinker -rpath -Xlinker @executable_path -Xswiftc -static-stdlib")
    system("install_name_tool -change #{yaml_lib_path} #{frameworks}/libCYaml.dylib #{xcodegen_path}")
    odie "Error building XcodeGen" if $CHILD_STATUS.exitstatus != 0
    frameworks.install yaml_lib_path
    bin.install xcodegen_path
  end

  test do
    output = `#{bin}/XcodeGen`
    assert !output.empty?, "Failed installing XcodeGen"
  end
end

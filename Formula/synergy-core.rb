class SynergyCore < Formula
  desc "Open source core of Synergy, the keyboard and mouse sharing tool"
  homepage "https://symless.com/synergy"
  url "https://github.com/symless/synergy-core.git",
      :revision => "62ab8ffc4fdbc84b51552d600a8e11f7a7b78d84"
  version "1.9.0-rc4"
  head "https://github.com/symless/synergy-core.git"

  depends_on "cmake" => :build
  depends_on "qt"
  depends_on "openssh"

  def install
    mkdir "build" do
      system "cmake",
        "-DOSX_TARGET_MAJOR=10",
        "-DCMAKE_OSX_SYSROOT=#{MacOS.sdk_path}",
        "-DCMAKE_OSX_DEPLOYMENT_TARGET=10.9",
        "-DCMAKE_OSX_ARCHITECTURES=x86_64",
        ".."

      system "make"

      bin.install "bin/synergyc"
      bin.install "bin/synergys"
    end
  end

  test do
    assert_match version.to_s[0, 5], shell_output(bin/"synergys --version | head -1")
    assert_match version.to_s[0, 5], shell_output(bin/"synergyc --version | head -1")
  end
end

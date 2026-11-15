class Qtshadertools < Formula
  desc "Provides tools for the cross-platform Qt shader pipeline"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.12/6.12.0/submodules/qtshadertools-everywhere-src-6.12.0.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.12/6.12.0/submodules/qtshadertools-everywhere-src-6.12.0.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.12/6.12.0/submodules/qtshadertools-everywhere-src-6.12.0.tar.xz"
  sha256 "c7d84f436e1aaef39fdcadebf2bd71bdf24dc69497e13f2e0198873cbbfea2ab"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] },
    { "GPL-3.0-only" => { with: "Qt-GPL-exception-1.0" } }, # qsb
    { all_of: ["Apache-2.0", "MIT-Khronos-old"] }, # bundled SPIRV-Cross
    { all_of: ["BSD-3-Clause", "MIT-Khronos-old", "Apache-2.0", "AML-glslang",
               "GPL-3.0-or-later" => { with: "Bison-exception-2.2" }] }, # bundled glslang
    "BSD-3-Clause", # *.cmake
  ]
  revision 1
  compatibility_version 1
  head "https://code.qt.io/qt/qtshadertools.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ce0f6de39dc8979ba041360ab5fcbd5aa585f573e60dbb775d4ba8ef600cb50f"
    sha256 cellar: :any, arm64_tahoe:       "ce8f56aa405011bebcaa4dcccefc310cb4b241396dcc2af4db3cefdd071ab44e"
    sha256 cellar: :any, arm64_sequoia:     "5666a2efc40797b9e07f47175c8552025b68a581ac15427f7b432c23fdbd6248"
    sha256 cellar: :any, arm64_linux:       "14f149ad4f3022336a96d8464de84ffbb8d95b98d3f63dba17efb50a9ad5a725"
    sha256 cellar: :any, x86_64_linux:      "d441c46cbff4308b951820fa0183679d73e1a7ef8e73dcbd9cf27a5b6ab96997"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  depends_on "qtbase"

  def install
    args = ["-DCMAKE_STAGING_PREFIX=#{prefix}"]
    args << "-DQT_NO_APPLE_SDK_AND_XCODE_CHECK=ON" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja",
                    *args, *std_cmake_args(install_prefix: HOMEBREW_PREFIX, find_framework: "FIRST")
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Some config scripts will only find Qt in a "Frameworks" folder
    frameworks.install_symlink lib.glob("*.framework") if OS.mac?
  end

  test do
    (testpath/"shader.frag").write <<~GLSL
      #version 440

      layout(location = 0) in vec2 v_texcoord;
      layout(location = 0) out vec4 fragColor;
      layout(binding = 1) uniform sampler2D tex;

      layout(std140, binding = 0) uniform buf {
        float uAlpha;
      };

      void main() {
        vec4 c = texture(tex, v_texcoord);
        fragColor = vec4(c.rgb, uAlpha);
      }
    GLSL

    ENV["LC_ALL"] = "en_US.UTF-8"
    system bin/"qsb", "--output", "shader.frag.qsb", "shader.frag"
    assert_path_exists testpath/"shader.frag.qsb"
    assert_match "Shader 0: SPIR-V 100", shell_output("#{bin}/qsb --dump shader.frag.qsb")
  end
end

class Qtshadertools < Formula
  desc "Provides tools for the cross-platform Qt shader pipeline"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.9/6.9.3/submodules/qtshadertools-everywhere-src-6.9.3.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.9/6.9.3/submodules/qtshadertools-everywhere-src-6.9.3.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.9/6.9.3/submodules/qtshadertools-everywhere-src-6.9.3.tar.xz"
  sha256 "629804ee86a35503e4b616f9ab5175caef3da07bd771cf88a24da3b5d4284567"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] },
    { "GPL-3.0-only" => { with: "Qt-GPL-exception-1.0" } }, # qsb
    { all_of: ["Apache-2.0", "MIT-Khronos-old"] }, # bundled SPIRV-Cross
    { all_of: ["BSD-3-Clause", "MIT-Khronos-old", "Apache-2.0", "AML-glslang",
               "GPL-3.0-or-later" => { with: "Bison-exception-2.2" }] }, # bundled glslang
    "BSD-3-Clause", # *.cmake
  ]
  head "https://code.qt.io/qt/qtshadertools.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bb579540bf38f45c33f8608e40022c7000e682eb4186d84264f8f240770a4e85"
    sha256 cellar: :any,                 arm64_sequoia: "205156158b29aa23357605ad9e2be6a4d784641dbf2dd42ac6d69107375ca84d"
    sha256 cellar: :any,                 arm64_sonoma:  "1e54af54279cb0d96388f878e4f8ffb4f1b46a22ef0ae292b86a5631b951b377"
    sha256 cellar: :any,                 sonoma:        "21f5464d71410117011e6035ab999264e902d90d28c91649d42b2aaded0f3830"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "64925118158a7861dd2d6291a7cee093ac87bbdc69db3857f8e87876e769e2a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de225d737f69ffacd8b1b130fa55dc1c6e844e5df18d876c73653821a947cc5a"
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

class Qtshadertools < Formula
  desc "Provides tools for the cross-platform Qt shader pipeline"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.10/6.10.2/submodules/qtshadertools-everywhere-src-6.10.2.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.10/6.10.2/submodules/qtshadertools-everywhere-src-6.10.2.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.10/6.10.2/submodules/qtshadertools-everywhere-src-6.10.2.tar.xz"
  sha256 "18d9dbbc4f7e6e96e6ed89a9965dc032e2b58158b65156c035537826216716c9"
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
    sha256 cellar: :any,                 arm64_tahoe:   "e1db09b4421d5214a83fcc970cadddcbdf0d843966545fec43031ca4370009ed"
    sha256 cellar: :any,                 arm64_sequoia: "75da294aa781428ae7eebe8c6314f68b584d48b0665f3999a20e23431df50613"
    sha256 cellar: :any,                 arm64_sonoma:  "cf106c527b0a0eefd854f596a040e14559380330b887d86cc22d968390515e0e"
    sha256 cellar: :any,                 sonoma:        "2dbe32335c1c01a689a30c9f7835cefeee0f472d108d50430617fee7f43fce31"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18b69a55adb7c0c8309c8c0a7ace86ca20b49607173964eb06f83f8f16f9f427"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da3bea745e68694e12a27ce818c975847b67449a843587dba3fc8cd26b9b29b1"
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

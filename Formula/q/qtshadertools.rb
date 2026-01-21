class Qtshadertools < Formula
  desc "Provides tools for the cross-platform Qt shader pipeline"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.10/6.10.1/submodules/qtshadertools-everywhere-src-6.10.1.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.10/6.10.1/submodules/qtshadertools-everywhere-src-6.10.1.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.10/6.10.1/submodules/qtshadertools-everywhere-src-6.10.1.tar.xz"
  sha256 "b67894a63352b53dad0d46f5300c62b8cd6783db575492d6b25d4fdc9af55bb6"
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
    sha256 cellar: :any,                 arm64_tahoe:   "de43cc730602f76688166af617ace911d958e18503e51e5732ca3294405bf8df"
    sha256 cellar: :any,                 arm64_sequoia: "2040f2504f3a13a6cfe0a1e49b8fcd4ab9fa1a68920828038c832652a447f262"
    sha256 cellar: :any,                 arm64_sonoma:  "4dd4f1fdb9f90122eb002be7159da411587ce0ee6354d45c976bfd8132d9d1a7"
    sha256 cellar: :any,                 sonoma:        "f07b392e02000d59c61c6a7b5553bde266a51938899af71e9e68a95dea2e4774"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "35491b1ce653001872522e4a9a09a077004fd9ff5e8363400dbee8b351563e67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b6235aaf6ca40f9de88529d6eff14a7b1c3cf014977d2b3cbc23d53333361e9"
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

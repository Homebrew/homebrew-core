class QtShadertools < Formula
  desc "Provides tools for the cross-platform Qt shader pipeline"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.8/6.8.2/submodules/qtshadertools-everywhere-src-6.8.2.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.8/6.8.2/submodules/qtshadertools-everywhere-src-6.8.2.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.8/6.8.2/submodules/qtshadertools-everywhere-src-6.8.2.tar.xz"
  sha256 "d1d5f90e8885fc70d63ac55a4ce4d9a2688562033a000bc4aff9320f5f551871"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] }, # main license
    { "GPL-3.0-only" => { with: "Qt-GPL-exception-1.0" } }, # tools/qsb/qsb.cpp
    { all_of: ["MIT-Khronos-old", any_of: ["Apache-2.0", "MIT"]] }, # src/3rdparty/SPIRV-Cross
    { all_of: ["BSD-3-Clause", "MIT-Khronos-old", "Apache-2.0", "AML-glslang",
               "GPL-3.0-or-later" => { with: "Bison-exception-2.2" }] }, # src/3rdparty/glslang
    "BSD-3-Clause", # installed cmake files
  ]
  head "https://code.qt.io/qt/qtshadertools.git", branch: "dev"

  livecheck do
    formula "qt"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "ninja" => :build
  depends_on xcode: :build

  depends_on "qt-base"

  uses_from_macos "zlib"

  def install
    # Allow -march options to be passed through, as Qt builds
    # arch-specific code with runtime detection of capabilities:
    # https://bugreports.qt.io/browse/QTBUG-113391
    ENV.runtime_cpu_detection

    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja",
                    "-DCMAKE_STAGING_PREFIX=#{prefix}",
                    *std_cmake_args(install_prefix: HOMEBREW_PREFIX, find_framework: "FIRST")
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

      void main()
      {
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

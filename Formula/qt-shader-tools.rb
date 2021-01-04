class QtShaderTools < Formula
  desc "Provide the producer functionality for the shader pipeline"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/archive/qt/6.0/6.0.0/submodules/qtshadertools-everywhere-src-6.0.0.tar.xz"
  sha256 "201b1376b65ef9f7fd19789781e0378ea813385217cd392c5c896699e6108e6c"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]

  bottle do
    root_url "https://dl.bintray.com/paperchalice/dev-bottle"
    cellar :any
    sha256 "8e0a867ce0857625d81ba690712e1f8ac6789a7c2b2daedc0d720c471eb74bf6" => :big_sur
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  depends_on "qt-base"

  def install
    args = std_cmake_args.reject { |s| s["CMAKE_INSTALL_PREFIX"] } + %W[
      -DCMAKE_INSTALL_PREFIX=/usr/local
      -DCMAKE_STAGING_PREFIX=#{prefix}
    ]
    system "cmake", "-G", "Ninja", ".", *args
    system "ninja"
    system "ninja", "install"

    # Some config scripts will only find Qt in a "Frameworks" folder
    frameworks.install_symlink Dir["#{lib}/*.framework"]

    # The pkg-config files installed suggest that headers can be found in the
    # `include` directory. Make this so by creating symlinks from `include` to
    # the Frameworks' Headers folders.
    Pathname.glob("#{lib}/*.framework/Headers") do |path|
      include.install_symlink path => path.parent.basename(".framework")
    end
  end

  test do
    (testpath/"shader.frag").write <<~EOS
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
    EOS

    system bin/"qsb", "-o", testpath/"shader.frag.qsb", testpath/"shader.frag"
    assert_predicate testpath/"shader.frag.qsb", :exist?
  end
end

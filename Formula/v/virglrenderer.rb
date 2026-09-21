class Virglrenderer < Formula
  include Language::Python::Virtualenv

  desc "VirGL virtual OpenGL renderer"
  homepage "https://gitlab.freedesktop.org/virgl/virglrenderer/"
  url "https://gitlab.freedesktop.org/virgl/virglrenderer/-/archive/1.3.0/virglrenderer-1.3.0.tar.bz2"
  sha256 "088040d130eaa0458a978fe7867fbfb1fcf1fdff52bf3b27a00658828bc4189f"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "849ad1a3ed02849c4a2d066d1284cd07624da4baa412759c4088e53bc5fbd01e"
    sha256 cellar: :any, arm64_tahoe:       "d82b1e4e7af7e434e07548417e5555deb27142fe20d4e1adef1c5a72b43c3a89"
    sha256 cellar: :any, arm64_sequoia:     "dcdc6584a0748af2e5abd4ba5532fb14944adf2a153ae353515cd076555ba7d4"
    sha256 cellar: :any, arm64_sonoma:      "6a062481a04adba4b4d96b5e5e17362c8b47f3882aa40c969ace63c8713301ce"
    sha256 cellar: :any, arm64_linux:       "d29f701ea302f35ef37d4a7438816525b1e3d9d0e72f127d00bf779cb6eeef24"
    sha256 cellar: :any, x86_64_linux:      "370ad6b6163a93b02ab9114e21b385863694ebdcac010e6e8d53416e36a809c6"
  end

  depends_on "libyaml" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => :build
  depends_on "libepoxy"
  depends_on "mesa"

  on_linux do
    depends_on "libdrm"
    depends_on "libx11"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  def install
    venv = virtualenv_create(buildpath/"venv", python3)
    venv.pip_install resource("pyyaml")
    ENV.prepend_path "PYTHONPATH", venv.site_packages

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <virglrenderer.h>
      int main(void) {
        struct virgl_renderer_callbacks cbs = {0};
        cbs.version = 1;
        // VIRGL_RENDERER_NO_VIRGL avoids need for EGL/GL context
        int ret = virgl_renderer_init(NULL, VIRGL_RENDERER_NO_VIRGL, &cbs);
        if (ret != 0) {
          fprintf(stderr, "virgl_renderer_init failed: %d\\n", ret);
          return 1;
        }
        virgl_renderer_poll();
        virgl_renderer_cleanup(NULL);
        printf("OK\\n");
        return 0;
      }
    C
    system ENV.cc, "test.c", "-o", "test", "-I#{include}/virgl", "-L#{lib}", "-lvirglrenderer"
    assert_equal "OK", shell_output("./test").chomp
  end
end

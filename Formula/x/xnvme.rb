class Xnvme < Formula
  desc "Cross-platform libraries and tools for efficient I/O and low-level control"
  homepage "https://xnvme.io/"
  url "https://github.com/OpenMPDK/xNVMe/releases/download/v0.7.4/xnvme-src-0.7.4.tar.gz"
  sha256 "6dd17ec256a3801d28f1e068aa1f61e82cf9a42eb30fcc81322ef04f637855f9"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "068b1893f5a637342821b2673d967a86f2a6a8c6bff50e7b3133e8cf6956569a"
    sha256 cellar: :any,                 arm64_ventura:  "76d887bddc8a20e8547a45c7eb151ac86d78cad34f6866c5d25af249f76c77d0"
    sha256 cellar: :any,                 arm64_monterey: "a8460f621deaeba81a4267ac2ac54063c6361fdcd1bdc9852f7793742f5b89c7"
    sha256 cellar: :any,                 sonoma:         "0aa9d7f368463240f12573381db654b7ccd618cfe4a43ca6cb97d4a4e21c746a"
    sha256 cellar: :any,                 ventura:        "c47660844b252c02ffeb3c7d48887d280e0f03b4fdc1119bfd1bca5b23a92fb6"
    sha256 cellar: :any,                 monterey:       "40bd5764d8a7497e77c1703347098bbd2e817e8ae8b141d7e73b2822dba792a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac49cfd271957269f63d78d14769188191047bbd22530f2a42a9a33b19b043b3"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]

  def install
    # We do not have SPDK nor libvfn on macOS, thus disabling these
    # The examples and tests are also a bit superfluous, so disable those as well
    system "meson", "setup", "build",
           *std_meson_args,
           "-Dwith-spdk=false",
           "-Dwith-libvfn=disabled",
           "-Dtests=false",
           "-Dexamples=false"
    system "meson", "compile", "-C", "build"
    system "meson", "install", "-C", "build"
  end

  test do
    # Verify cli usage using a "ramdisk" of 1GB
    output = shell_output("#{bin}/xnvme library-info")
    assert_match "XNVME_BE_RAMDISK_ENABLED", output

    output = shell_output("#{bin}/xnvme info 1GB --be ramdisk")
    assert_match "uri: '1GB'", output
    assert_match "type: XNVME_GEO_CONVENTIONAL", output
    assert_match "tbytes: 1073741824", output

    # Verify library usage using a ramdisk of 1GB
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <libxnvme.h>

      int main(int argc, char **argv) {
        struct xnvme_opts opts = xnvme_opts_default();
        struct xnvme_dev *dev;

        dev = xnvme_dev_open("1GB", &opts);
        if (!dev) {
          perror("xnvme_dev_open()");
          return 1;
        }

        xnvme_dev_pr(dev, XNVME_PR_DEF);
        xnvme_dev_close(dev);

        return 0;
      }
    EOS

    # Build the example using pkg-config for build-options
    flags = shell_output("pkg-config xnvme --libs --cflags").strip
    system ENV.cc, "test.c", "-o", "test", *flags.split

    # Run it and check the output, this should produce the same output as the
    # 'xnvme library-info' command, thus the output-assertion is the same
    output = shell_output("./test info 1GB --be ramdisk")
    assert_match "uri: '1GB'", output
    assert_match "type: XNVME_GEO_UNKNOWN", output
    assert_match "tbytes: 0", output
  end
end

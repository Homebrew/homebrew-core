class Xnvme < Formula
  desc "Cross-platform libraries and tools for efficient I/O and low-level control"
  homepage "https://xnvme.io/"
  url "https://github.com/xnvme/xnvme/releases/download/v0.7.5/xnvme-fat-0.7.5.tar.gz"
  sha256 "67e1e55966f150c68cbe386112202cb3d1af8831b7202a251986b7e63cf34f3a"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f5a3ced6f2d26e622f6a619c2f8606916aafb9c6704cb58a52a7b976f9f00fdc"
    sha256 cellar: :any,                 arm64_sequoia: "669d2c6ac4f5091f07ec36cd8376e6dde81e8c38d20154efa1b038e7b1d2b391"
    sha256 cellar: :any,                 arm64_sonoma:  "387a8c914b0348bda2aa34f3d15292f649f768ff8a4a4baa329659200b903681"
    sha256 cellar: :any,                 arm64_ventura: "98be4270d703ba24e95af9714302b41bf45346a3ecc69220889a889381210c9d"
    sha256 cellar: :any,                 sonoma:        "ab2c11503d96c5d333b599ce0c2a18a4f25712bb8c7c53c681b34de481d8c6b4"
    sha256 cellar: :any,                 ventura:       "f91938361da2f149e42e493be2702bafbc55221854f92c40cc5a7b3ffef7639b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9d905badf1945c4991a143fb6d817d510998578f76afe30130894b1eae8a07e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f6f44f9a1deeec057afbff777aa156acf353fbf02f6c85ecb858a4d741baf69"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]

  def install
    # We do not have SPDK nor libvfn on macOS, thus disabling these
    # The examples and tests are also a bit superfluous, so disable those as well
    args = %w[
      -Dwith-spdk=disabled
      -Dwith-libvfn=disabled
      -Dtests=false
      -Dexamples=false
    ]
    system "meson", "setup", "build", *args, *std_meson_args
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
    (testpath/"test.c").write <<~C
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
    C

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

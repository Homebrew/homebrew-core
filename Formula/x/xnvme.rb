class Xnvme < Formula
  desc "Cross-platform libraries and tools for efficient I/O and low-level control"
  homepage "https://xnvme.io/"
  url "https://github.com/xnvme/xnvme/releases/download/v0.8.1/xnvme-fat-0.8.1.tar.gz"
  sha256 "3718417f4637949091815a77a3d4bf4512c9adedb5d0ca0886496e36a32fe8f8"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "e0ab19cfc66d3d55b2b148979d7c84342a061da1da15c18dae8276e0900537ce"
    sha256 arm64_golden_gate: "46d270a82735bac8d4ca107cbb464382b1293f4978d8926e599a6dc78fda0893"
    sha256 arm64_tahoe:       "fe79b0a39804dcf7f1c258989e6649756e0cb06bdb311fc52b44212b4de05938"
    sha256 arm64_sequoia:     "1b786a2f878d6680518800812b059f0ca026a47803a8f46ef873c1281356900c"
    sha256 arm64_linux:       "e59f3480ad4fba4cb298fe56b6302f1c3b3a0f1e5cc2d8d1d45ba8018e973185"
    sha256 x86_64_linux:      "fa28bfa322c2a9e07efd380d06b4af4cef8c138980160358200cc8720b4e5141"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]

  deny_network_access!

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

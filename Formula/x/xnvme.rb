class Xnvme < Formula
  desc "Cross-platform libraries and tools for efficient I/O and low-level control"
  homepage "https://xnvme.io/"
  url "https://github.com/xnvme/xnvme/releases/download/v0.8.0/xnvme-fat-0.8.0.tar.gz"
  sha256 "2cee620380a7df8180825c0028cfb72ed9f1ed95a5e8ccf37351e3825bd93111"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "c8c0c1bcfc668b78a3813bbef270f13421881d8b8ed43722b6f43df04bb775f6"
    sha256 arm64_golden_gate: "074a7b82762d56cf16e1d9383ab5c223e0d1ef1aa5dce60fd06d08885f655a50"
    sha256 arm64_tahoe:       "8252a91117b1c44025e68495393804c20212adaba615716783f820c55c7e230e"
    sha256 arm64_sequoia:     "ad1022655309654cc7ed637a79ef0cabe774e047ec06d8f6863559e162c9f4b0"
    sha256 arm64_linux:       "9d5d4efbd7cc5e0df30e5338a39b337a394ea4c6266f81e7d4754864b3f706be"
    sha256 x86_64_linux:      "18d55160e9b7424214929f4aa49b983fc9c7da9e343ac1a6b473f5752c46c5cf"
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

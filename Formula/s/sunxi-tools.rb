class SunxiTools < Formula
  desc "Command-line tools for Allwinner SoC devices"
  homepage "https://github.com/linux-sunxi/sunxi-tools"
  url "https://github.com/linux-sunxi/sunxi-tools/archive/30351865a9b13093a9e4d9a78bf2bf41ad9189ad/sunxi-tools-30351865a9b13093a9e4d9a78bf2bf41ad9189ad.tar.gz"
  version "1.4.2-205-g3035186"
  sha256 "295eaa2f128af3d10fad0497d13e9c286de0253b6f7a1cf2a8b9de1c07657e8c"
  license "GPL-2.0-or-later"
  head "https://github.com/linux-sunxi/sunxi-tools.git", branch: "master"

  no_autobump! because: :incompatible_version_format

  depends_on "pkgconf" => :build

  depends_on "dtc"
  depends_on "libusb"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    if build.stable?
      (buildpath/"version.h").write <<~C
        /* Auto-generated information. DO NOT EDIT */
        #define VERSION "#{version}"
      C
    end

    system "make", "install-tools", "PREFIX=#{prefix}"
  end

  test do
    expected_version = build.head? ? /v?1\.4\.2-\d+-g[0-9a-f]+/ : version.to_s

    assert_match expected_version, shell_output("#{bin}/sunxi-fel --help 2>&1")
    assert_match expected_version, shell_output("#{bin}/sunxi-fexc -? 2>&1", 1)
  end
end

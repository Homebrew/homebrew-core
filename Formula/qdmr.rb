class Qdmr < Formula
  desc "Codeplug programming tool for DMR radios"
  homepage "https://dm3mat.darc.de/qdmr/"
  url "https://github.com/hmatuschek/qdmr/archive/refs/tags/v0.11.2.tar.gz"
  sha256 "812e51ac9e2c4fe430673d8f7c9a2f351feb5f70275755c6da88e26bbab2b272"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_ventura:  "9f9e5910625df0f7897bc51cdc652e66a445293f351d0e07041009c15df06fc3"
    sha256 arm64_monterey: "835b15ebcf170ab9fe42771785fc5a6429843ad1dde5309a1d8c0d5ac683ad5a"
    sha256 arm64_big_sur:  "149b1a4cbcf0c671dd597a791189c2cfd9c9214f5f00290d736a065adc68002d"
    sha256 ventura:        "1d4cf81c6a95c0877fc0bda0d7f8627005336d429ec612224cb11231cfc47750"
    sha256 monterey:       "95e440a52946065b7aabfc640bc6c809b74b08b08a76442d24689b87ce4c8bbd"
    sha256 big_sur:        "f3ad0bd0bc1a61f5d18a74b2f4a6faaca791b6c83524b912253da6e83bd038c8"
    sha256 x86_64_linux:   "fe3a8652b0b152b832a5bd27de6d49a22b45371083df26f51e684c01037be032"
  end

  depends_on "cmake" => :build
  depends_on "libusb"
  depends_on "qt@5"
  depends_on "yaml-cpp"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DINSTALL_UDEV_RULES=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"config.yaml").write <<~EOS
      radioIDs:
        - dmr: {id: id1, name: DM3MAT, number: 2621370}

      channels:
        - dmr:
            id: ch1
            name: "Test Channel"
            rxFrequency: 123.456780   # <- Up to 10Hz precision
            txFrequency: 1234.567890

    EOS
    system bin/"dmrconf", "--radio=d878uv2", "encode", "config.yaml", "config.dfu"
  end
end

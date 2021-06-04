class Qca < Formula
  desc "Qt Cryptographic Architecture (QCA)"
  homepage "https://userbase.kde.org/QCA"
  url "https://download.kde.org/stable/qca/2.3.3/qca-2.3.3.tar.xz"
  sha256 "562e8f9b8542944e2c0c18c45c05bb202f620db84032790c54b424454f727b67"
  license "LGPL-2.1-or-later"
  head "https://invent.kde.org/libraries/qca.git"

  livecheck do
    url "https://download.kde.org/stable/qca/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "2bb968c7a243d1ffe7d1806dfb6c8454343c6b56da3df6a6742cce67ad67b5e4"
    sha256 cellar: :any, big_sur:       "bb378103f30533f189ce099b8f15b26999595592c49da114329d8947f10284d3"
    sha256 cellar: :any, catalina:      "baad850d36e7bd2274b09a600bfe40415994a75c6fce8e07dae612ba446c876b"
    sha256 cellar: :any, mojave:        "77525c2da0d1f7c77b33058ee58b000bb8f823c2b1c90626d1652b804b2354e6"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "botan"
  depends_on "gnupg"
  depends_on "libgcrypt"
  depends_on "nss"
  depends_on "openssl@1.1"
  depends_on "pkcs11-helper"
  depends_on "qt@5"

  def install
    args = std_cmake_args
    args << "-DBUILD_TESTS=OFF"
    args << "-DQCA_PLUGINS_INSTALL_DIR=#{lib}/qt5/plugins"

    # Disable some plugins. qca-ossl, qca-cyrus-sasl, qca-logger,
    # qca-softstore are always built.
    args << "-DWITH_botan_PLUGIN=ON"
    args << "-DWITH_gcrypt_PLUGIN=ON"
    args << "-DWITH_gnupg_PLUGIN=ON"
    args << "-DWITH_nss_PLUGIN=ON"
    args << "-DWITH_pkcs11_PLUGIN=ON"

    # ensure opt_lib for framework install name and linking (can't be done via CMake configure)
    inreplace "src/CMakeLists.txt",
              /^(\s+)(INSTALL_NAME_DIR )("\$\{QCA_LIBRARY_INSTALL_DIR\}")$/,
             "\\1\\2\"#{opt_lib}\""

    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    system bin/"qcatool-qt5", "--noprompt", "--newpass=",
                              "key", "make", "rsa", "2048", "test.key"
  end
end

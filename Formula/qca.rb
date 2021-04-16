class Qca < Formula
  desc "Qt Cryptographic Architecture (QCA)"
  homepage "https://userbase.kde.org/QCA"
  url "https://download.kde.org/stable/qca/2.3.2/qca-2.3.2.tar.xz"
  sha256 "4697600237c4bc3a979e87d2cc80624f27b06280e635f5d90ec7dd4d2a9f606d"
  license "LGPL-2.1-or-later"
  revision 2
  head "https://invent.kde.org/libraries/qca.git"

  livecheck do
    url "https://download.kde.org/stable/qca/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "c7418226a595f1d0e97f0498a46b1d20c082616efe551ed0cf39505825dc31fe"
    sha256 cellar: :any, big_sur:       "7e35ffca6cece212af914e61e9d382664b4db6af2adcbc57192d45e2406b7032"
    sha256 cellar: :any, catalina:      "f8590fab29733c68f0b19d2e78ebc6273569bbf581e7ab68e875fb0e140e25f9"
    sha256 cellar: :any, mojave:        "4d54d803d64b150f9f4dcd055108951f6c8a774b587d57ba33a6da5a99c34bb7"
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

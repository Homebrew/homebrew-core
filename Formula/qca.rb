class Qca < Formula
  desc "Qt Cryptographic Architecture (QCA)"
  homepage "https://userbase.kde.org/QCA"
  url "https://download.kde.org/stable/qca/2.3.2/qca-2.3.2.tar.xz"
  sha256 "4697600237c4bc3a979e87d2cc80624f27b06280e635f5d90ec7dd4d2a9f606d"
  license "LGPL-2.1-or-later"
  head "https://invent.kde.org/libraries/qca.git"

  livecheck do
    url "https://download.kde.org/stable/qca/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "a49811534e35b364eb5ef5934cf2f938a3a936d1361636e9679cdd66f68a84b3"
    sha256 cellar: :any, big_sur:       "bd2f1c1a96765e12401294d47b5c238f73df154adf9f75cbd4e7b1743d5ff6e5"
    sha256 cellar: :any, catalina:      "3eb85a38faa170044765c86ec4add3ab13a403bcd8b681e2c0f03f6a20d0c864"
    sha256 cellar: :any, mojave:        "4c5fd2f5004d77a33179eb45e7dd4d04c93c0797460b381f36c3fad0e546fe39"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "botan"
  depends_on "gnupg"
  depends_on "libgcrypt"
  depends_on "nss"
  depends_on "openssl@1.1"
  depends_on "pkcs11-helper"
  depends_on "qt"

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

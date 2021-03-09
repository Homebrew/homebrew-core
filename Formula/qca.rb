class Qca < Formula
  desc "Qt Cryptographic Architecture (QCA)"
  homepage "https://userbase.kde.org/QCA"
  url "https://download.kde.org/stable/qca/2.3.2/qca-2.3.2.tar.xz"
  sha256 "4697600237c4bc3a979e87d2cc80624f27b06280e635f5d90ec7dd4d2a9f606d"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://invent.kde.org/libraries/qca.git"

  livecheck do
    url "https://download.kde.org/stable/qca/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "27409ec10e90ea2f1c6ab4c0cf343ad578ffe2d24f4ef4c8effb1ee9486c9367"
    sha256 cellar: :any, big_sur:       "13f763f5765519e0ae2abdbd29157c913b2921a574858aae30adbcdaf2c26673"
    sha256 cellar: :any, catalina:      "50c9fc8e51d570d965a70a978877e4b8aa632d61e6a8c836697ee7e046e1bffb"
    sha256 cellar: :any, mojave:        "f9c79cd7db5b5c539ca73afd55b1acde851f8ca5180607265a83f72d7a29cde1"
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

class Qca < Formula
  desc "Qt Cryptographic Architecture (QCA)"
  homepage "https://userbase.kde.org/QCA"
  url "https://download.kde.org/stable/qca/2.3.2/qca-2.3.2.tar.xz"
  sha256 "4697600237c4bc3a979e87d2cc80624f27b06280e635f5d90ec7dd4d2a9f606d"
  license "LGPL-2.1-or-later"
  head "https://invent.kde.org/libraries/qca.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "4d4c37739a1afeeb5623bdbc7800b82652a93e02770cdc06b63379ae35746223"
    sha256 cellar: :any, big_sur:       "0ce2bbd226e16d2e037c61f404123be202e6b3be814f3eab5be83f95f6803978"
    sha256 cellar: :any, catalina:      "55a109c49bc235dd6423f5924b3879c3c9677670bc45650306aa5f14cf9877aa"
    sha256 cellar: :any, mojave:        "41ba9d1f97eab606b1cf30566fa3b8f4a3c1bdf06b32c74deab067896fa6db7a"
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

class Qca < Formula
  desc "Qt Cryptographic Architecture (QCA)"
  homepage "https://userbase.kde.org/QCA"
  url "https://download.kde.org/stable/qca/2.3.5/qca-2.3.5.tar.xz"
  sha256 "91f7d916ab3692bf5991f0a553bf8153161bfdda14bd005d480a2b4e384362e8"
  license "LGPL-2.1-or-later"
  head "https://invent.kde.org/libraries/qca.git", branch: "master"

  livecheck do
    url "https://download.kde.org/stable/qca/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "16589df8730a36b0b7b9c1cf08a31450cd631504d008ca42b360f55c0e046542"
    sha256 cellar: :any,                 arm64_big_sur:  "e385d8e8182b3ab1d0620b96fc450725ddb902953cc472a91a6222edae863ece"
    sha256 cellar: :any,                 monterey:       "0a75b00d7c90332bba605e535950f7fbd6f0d314c218c0d5f3dbdfddd2104c5e"
    sha256 cellar: :any,                 big_sur:        "a2f76da05b592bfc03fecc9f2243b64764e195c5456597cab1e776c4b335298e"
    sha256 cellar: :any,                 catalina:       "0a53f741a3453fd8af203781f8dd8aad6dea1969b287022aa5cae2fb834972e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7691afbaafb94e0cd81e573e69c80afe8cc224fe4dafec8e9c25ee3bfb7292c8"
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

  fails_with gcc: "5"

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

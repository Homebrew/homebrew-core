class Qca < Formula
  desc "Qt Cryptographic Architecture (QCA)"
  homepage "https://userbase.kde.org/QCA"
  license "LGPL-2.1"
  revision 1
  head "https://invent.kde.org/libraries/qca.git"

  stable do
    url "https://download.kde.org/stable/qca/2.3.1/qca-2.3.1.tar.xz"
    sha256 "c13851109abefc4623370989fae3a745bf6b1acb3c2a13a8958539823e974e4b"

    # use major version for framework, instead of full version
    # see: https://invent.kde.org/libraries/qca/-/merge_requests/34
    patch do
      url "https://invent.kde.org/libraries/qca/-/commit/f899a6aaad6747c703a9ee438a4a75bd7f6052f4.diff"
      sha256 "1ae6e279d3e1e4dbe10ff80908517dab29e2b538f7c79384901d28bed69cbc9e"
    end
  end

  bottle do
    cellar :any
    sha256 "fd1c57be0df0d989b83b63b6c4a7a209b01836053e96fa8de4d4548bcb716fd9" => :catalina
    sha256 "5545e3bda522faa06f2ee93d8013bf0558d463562a301cd5f9eb51426ac77f6d" => :mojave
    sha256 "baef310d539b7638144448b203134aca401a797599ba34f2a8bab0193f6bce6a" => :high_sierra
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

class Qca < Formula
  desc "Qt Cryptographic Architecture (QCA)"
  homepage "https://userbase.kde.org/QCA"
  url "https://download.kde.org/stable/qca/2.3.4/qca-2.3.4.tar.xz"
  sha256 "6b695881a7e3fd95f73aaee6eaeab96f6ad17e515e9c2b3d4b3272d7862ff5c4"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://invent.kde.org/libraries/qca.git", branch: "master"

  livecheck do
    url "https://download.kde.org/stable/qca/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "98d19292c58b6c97318f57f28fabe01f3fd47fc6468fdeae5332b216c98a2ed7"
    sha256 cellar: :any, arm64_big_sur:  "c48666bc26a0fa8feb41eac998a47e16dad343e2b6492dd9c70fd42e542c7e0b"
    sha256 cellar: :any, monterey:       "35ee3bfc6250c22dc31d22a480fb03f899e1905718bb2687057450a295263b37"
    sha256 cellar: :any, big_sur:        "5b6a1f3bfda2eb1f81ae83b7dcfff6ff76c5531944537d588db5b74dbf4d8cb3"
    sha256 cellar: :any, catalina:       "f35cba38f07f642e6645d9efb8972714ea801b44020e6ad74749022611edf298"
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

  on_linux do
    depends_on "gcc"
  end

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

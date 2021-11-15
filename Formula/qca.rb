class Qca < Formula
  desc "Qt Cryptographic Architecture (QCA)"
  homepage "https://userbase.kde.org/QCA"
  url "https://download.kde.org/stable/qca/2.3.4/qca-2.3.4.tar.xz"
  sha256 "6b695881a7e3fd95f73aaee6eaeab96f6ad17e515e9c2b3d4b3272d7862ff5c4"
  license "LGPL-2.1-or-later"
  head "https://invent.kde.org/libraries/qca.git", branch: "master"

  livecheck do
    url "https://download.kde.org/stable/qca/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "1078397c4e720750cfe4458356fd1d3d60b8d14c055fee9b485285b0ddae497c"
    sha256 cellar: :any, arm64_big_sur:  "3a2f700c9fbc3f1cdb941f8547345415a312397411f1ec1df5b2867a8f139955"
    sha256 cellar: :any, big_sur:        "8049ff19056de9b02f71ab6bcda1cee91941d7bc0d4db3a17a6039b786470ae5"
    sha256 cellar: :any, catalina:       "ac7fc8b88014e339d556e136f73c8db0246bef6ae65abe15c8f13858c8bd95b1"
    sha256 cellar: :any, mojave:         "fc6386d75f4474fecc8710d99887a4f6c81dace19bd5eddaac5b20270664b0ea"
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

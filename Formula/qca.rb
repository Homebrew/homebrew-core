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
    sha256 cellar: :any,                 arm64_ventura:  "67d5097b20c620a623943308de5f36121a03b5a1c8c337a0f13d845d5a97f4a4"
    sha256 cellar: :any,                 arm64_monterey: "72c68247c8a7073dd64124a693f5ed7322ad2814864d400318538032b9914a77"
    sha256 cellar: :any,                 arm64_big_sur:  "3f5be21bda3c7d6c83de3a970d8973fa72de6e9e59a8a4147f943dced7205784"
    sha256 cellar: :any,                 ventura:        "aa9f0abfbd15d417c8c0330d7691478222c414ad12395ad2e93e8bcc5e2a3f34"
    sha256 cellar: :any,                 monterey:       "daf1cd48fba9f474cd6ff76965d3b7fc7147a2ea070a07a116f698dbc9add316"
    sha256 cellar: :any,                 big_sur:        "d3941047481b3790b96c631c18693c5e81e15ba74478f2c242df01bd43b1ea95"
    sha256 cellar: :any,                 catalina:       "ddfac4f0f08816d6c2f0f10b9b1b22001e21f18cf9a952852d9b8caf6511e0e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f89b94e7bbf13f16553a66aa0e054782d8002b2315315c2fa11e29d20d15ea45"
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

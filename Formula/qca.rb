class Qca < Formula
  desc "Qt Cryptographic Architecture (QCA)"
  homepage "https://userbase.kde.org/QCA"
  revision 1
  head "https://anongit.kde.org/qca.git"

  stable do
    url "https://github.com/KDE/qca/archive/v2.2.1.tar.gz"
    sha256 "c67fc0fa8ae6cb3d0ba0fbd8fca8ee8e4c5061b99f1fd685fd7d9800cef17f6b"

    # use major version for framework, instead of full version
    # see: https://github.com/KDE/qca/pull/3
    patch do
      url "https://github.com/KDE/qca/pull/3.patch?full_index=1"
      sha256 "37281b8fefbbdab768d7abcc39fb1c1bf85159730c2a4de6e84f0bf318ebac2c"
    end
  end

  bottle do
    sha256 "56923c31aaa91a00f6692f135e8f5889182b770d08800f90f0ae685a6edd5b4a" => :mojave
    sha256 "df6120a7a524c85100ff94912a364903d4eeae0529ab1a24a0e72aa66f52dfa7" => :high_sierra
    sha256 "1a498fc1f967cf8290d4d0748d7d003442047f5358bb368c4e41d49681799f5d" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@1.1" # qca-ossl plugin
  depends_on "qt"

  def install
    args = std_cmake_args
    args << "-DQT4_BUILD=OFF"
    args << "-DBUILD_TESTS=OFF"
    args << "-DQCA_PLUGINS_INSTALL_DIR=#{lib}/qt5/plugins"

    # Disable some plugins. qca-ossl, qca-cyrus-sasl, qca-logger,
    # qca-softstore are always built.
    args << "-DWITH_botan_PLUGIN=NO"
    args << "-DWITH_gcrypt_PLUGIN=NO"
    args << "-DWITH_gnupg_PLUGIN=NO"
    args << "-DWITH_nss_PLUGIN=NO"
    args << "-DWITH_pkcs11_PLUGIN=NO"

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

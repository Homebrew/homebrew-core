class Qca < Formula
  desc "Qt Cryptographic Architecture (QCA)"
  homepage "https://userbase.kde.org/QCA"
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
    rebuild 2
    sha256 "2bb9c83e54cd7ffef77b7111c1163ce2aa2efe450aab7be62c4ba4f8968f2bfc" => :mojave
    sha256 "ec20d95d269615e6ab276c21866b54ecd13fcaf33d543e47b8b9f45362f4d801" => :high_sierra
    sha256 "23eeb0c71865eaa6e5c29311480bbdcf2a80aa9c818853e8b7155b5a97689fb1" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl" # qca-ossl plugin
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

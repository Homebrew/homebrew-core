class Qca < Formula
  desc "Qt Cryptographic Architecture (QCA)"
  homepage "https://userbase.kde.org/QCA"
  head "https://anongit.kde.org/qca.git"

  stable do
    url "https://github.com/KDE/qca/archive/v2.3.0.tar.gz"
    sha256 "39aa18f0985d82949f4dccce04af3eb8d4b6b64e0c71785786738d38d8183b0a"

    # use major version for framework, instead of full version
    # see: https://github.com/KDE/qca/pull/3
    patch do
      url "https://github.com/KDE/qca/pull/3.patch?full_index=1"
      sha256 "37281b8fefbbdab768d7abcc39fb1c1bf85159730c2a4de6e84f0bf318ebac2c"
    end
  end

  bottle do
    cellar :any
    sha256 "5af8a815c4534787388cf0d11773e62d8ab906e4b68a52a7e3230bdb0dc97249" => :catalina
    sha256 "c8b2be92c664d56c6e4bc3ced579181127bf263cffcc900c62dc1943bf40cf69" => :mojave
    sha256 "3735156d4a76e9f18f01fd7c056698f914f2f932650349dda0bd543942057882" => :high_sierra
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

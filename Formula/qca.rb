class Qca < Formula
  desc "Qt Cryptographic Architecture (QCA)"
  homepage "http://delta.affinix.com/qca/"
  revision 2
  head "https://anongit.kde.org/qca.git"

  stable do
    url "https://github.com/KDE/qca/archive/v2.1.3.tar.gz"
    sha256 "a5135ffb0250a40e9c361eb10cd3fe28293f0cf4e5c69d3761481eafd7968067"

    # upstream fixes for macOS building (remove on 2.2.0 upgrade)
    patch do
      url "https://github.com/KDE/qca/commit/7ba0ee591e0f50a7e7b532f9eb7e500e7da784fb.diff?full_index=1"
      sha256 "3f6c8a8bbd246556c690142c209a34973981be66e46fee991a456fb2e8b66d72"
    end
    patch do
      url "https://github.com/KDE/qca/commit/b435c1b87b14ac2d2de9f83e586bfd6d8c2a755e.diff?full_index=1"
      sha256 "9ea01ad6b21282ff62b18ac02588f7106b75056ab8379dff3fdfcff13a6c122f"
    end
    patch do
      url "https://github.com/KDE/qca/commit/f4b2eb0ced5310f3c43398eb1f03e0c065e08a82.diff?full_index=1"
      sha256 "d6c27ebfd8fec5284e4a0a39faf62e44764be5baff08141bd7f4da6d0b9f438d"
    end

    # use major version for framework, instead of full version
    # see: https://github.com/KDE/qca/pull/3
    patch do
      url "https://github.com/KDE/qca/pull/3.patch?full_index=1"
      sha256 "37281b8fefbbdab768d7abcc39fb1c1bf85159730c2a4de6e84f0bf318ebac2c"
    end
  end

  bottle do
    sha256 "f4ab4894a879fd46f307b2b0a85579bab21597751e747f98dc6c6e6c280ed51a" => :high_sierra
    sha256 "f1e667b1e659abf24cad1170de0228c44a359f90b5698ab8422790f804d91245" => :sierra
    sha256 "a90f2bab8c7bbd0817daf660493aceaaab156db1acfa80116bf57c4ec75b6169" => :el_capitan
  end

  option "with-api-docs", "Build API documentation"

  deprecated_option "with-gnupg" => "with-gpg2"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "qt"

  # Plugins (QCA needs at least one plugin to do anything useful)
  depends_on "openssl" # qca-ossl
  depends_on "botan" => :optional # qca-botan
  depends_on "libgcrypt" => :optional # qca-gcrypt
  depends_on :gpg => [:optional, :run] # qca-gnupg
  depends_on "nss" => :optional # qca-nss
  depends_on "pkcs11-helper" => :optional # qca-pkcs11

  if build.with? "api-docs"
    depends_on "graphviz" => :build
    depends_on "doxygen" => :build
  end

  def install
    args = std_cmake_args
    args << "-DQT4_BUILD=OFF"
    args << "-DBUILD_TESTS=OFF"
    args << "-DQCA_PLUGINS_INSTALL_DIR=#{lib}/qt5/plugins"

    # Plugins (qca-ossl, qca-cyrus-sasl, qca-logger, qca-softstore always built)
    args << "-DWITH_botan_PLUGIN=#{build.with?("botan") ? "YES" : "NO"}"
    args << "-DWITH_gcrypt_PLUGIN=#{build.with?("libgcrypt") ? "YES" : "NO"}"
    args << "-DWITH_gnupg_PLUGIN=#{build.with?("gpg2") ? "YES" : "NO"}"
    args << "-DWITH_nss_PLUGIN=#{build.with?("nss") ? "YES" : "NO"}"
    args << "-DWITH_pkcs11_PLUGIN=#{build.with?("pkcs11-helper") ? "YES" : "NO"}"

    # ensure opt_lib for framework install name and linking (can't be done via CMake configure)
    inreplace "src/CMakeLists.txt",
              /^(\s+)(INSTALL_NAME_DIR )("\$\{QCA_LIBRARY_INSTALL_DIR\}")$/,
             "\\1\\2\"#{opt_lib}\""

    system "cmake", ".", *args
    system "make", "install"

    if build.with? "api-docs"
      system "make", "doc"
      doc.install "apidocs/html"
    end
  end

  test do
    system bin/"qcatool-qt5", "--noprompt", "--newpass=",
                              "key", "make", "rsa", "2048", "test.key"
  end
end

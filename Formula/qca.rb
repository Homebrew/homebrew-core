class Qca < Formula
  desc "Qt Cryptographic Architecture (QCA)"
  homepage "http://delta.affinix.com/qca/"
  head "https://anongit.kde.org/qca.git"
  revision 1

  stable do
    url "https://github.com/KDE/qca/archive/v2.1.3.tar.gz"
    sha256 "a5135ffb0250a40e9c361eb10cd3fe28293f0cf4e5c69d3761481eafd7968067"

    # upstream fixes for macOS building (remove on 2.2.0 upgrade)
    patch do
      url "https://github.com/KDE/qca/commit/7ba0ee591e0f50a7e7b532f9eb7e500e7da784fb.diff"
      sha256 "fee535fdd01c1ba981bb5ece381cfa01e6e3decca38d62b24c4f20fd8620c1ce"
    end
    patch do
      url "https://github.com/KDE/qca/commit/b435c1b87b14ac2d2de9f83e586bfd6d8c2a755e.diff"
      sha256 "187de5c4f4cb8975ca562ee7ca38592ce12a844b9606a68af8e3dd932f67818d"
    end
    patch do
      url "https://github.com/KDE/qca/commit/f4b2eb0ced5310f3c43398eb1f03e0c065e08a82.diff"
      sha256 "a3529a29dd55008be9575bc965cb760365b650a62f5c6c8c441d433e9c9556db"
    end

    # use major version for framework, instead of full version
    # see: https://github.com/KDE/qca/pull/3
    patch do
      url "https://github.com/KDE/qca/pull/3.patch"
      sha256 "ec90fc28c64629ecb81571f5d0e4962cfd6237892b692ac488cd0c87a0adb7b9"
    end
  end

  bottle do
    sha256 "d906fecec28f2af312e2309398c43c9d5208ace0a24f65462d5c0ee6999acaa6" => :sierra
    sha256 "7ef949fefdbddb7309cd3f687fa2ad2a4c02622b7ca92d7416494bd13d40eb4c" => :el_capitan
    sha256 "d3a865bed9af87d7d54b87080cc973341385ced03dd5d257a9bc590e4d656c80" => :yosemite
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
    depends_on "doxygen" => [:build, "with-graphviz"]
  end

  def install
    args = std_cmake_args
    args << "-DQT4_BUILD=OFF"
    args << "-DBUILD_TESTS=OFF"

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

class Qca < Formula
  desc "Qt Cryptographic Architecture (QCA)"
  homepage "https://userbase.kde.org/QCA"
  url "https://download.kde.org/stable/qca/2.3.5/qca-2.3.5.tar.xz"
  sha256 "91f7d916ab3692bf5991f0a553bf8153161bfdda14bd005d480a2b4e384362e8"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://invent.kde.org/libraries/qca.git", branch: "master"

  livecheck do
    url "https://download.kde.org/stable/qca/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6eb73810b19991343b6b15c23d8b4807c55693b5721ad15322ad1f6bc6504cd7"
    sha256 cellar: :any,                 arm64_monterey: "8f411490dcd475a5b5b57c5e5ee6e2e812bcdc340ba84bb1426e0038d6184439"
    sha256 cellar: :any,                 arm64_big_sur:  "f734c8a40e7a988c64a6f165320c2441ff563bc938da1219f23f638c60a27841"
    sha256 cellar: :any,                 ventura:        "b2af87ec7486bd69a1f9baf6c4e20c26959c768c249179835dfa933b9e38ad13"
    sha256 cellar: :any,                 monterey:       "8c8576efae870b57bd4557486ba06c60808dffff71d7cc0e31be0b605367172a"
    sha256 cellar: :any,                 big_sur:        "d2050d894f533a2829894f2d6f164e59cce9865284c446ebf78760d07caf5eaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c202fc6a6afbd099fbcfe6ceaf8e0999ca6a2682e7cdabee597716a7862452bf"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "botan"
  depends_on "gnupg"
  depends_on "libgcrypt"
  depends_on "nss"
  depends_on "openssl@3"
  depends_on "pkcs11-helper"
  depends_on "qt@5"

  fails_with gcc: "5"

  # upstream PR ref, https://invent.kde.org/libraries/qca/-/merge_requests/96
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/f59e193/qca/botan3.patch"
    sha256 "c18347df70834668fe049203d33ea68dd63471989acf923e39ec5eaddc42cc36"
  end

  def install
    # Make sure we link with OpenSSL 3 and not OpenSSL 1.1.
    openssl11 = Formula["openssl@1.1"]
    ENV.remove "CMAKE_PREFIX_PATH", openssl11.opt_prefix
    ENV.remove ["CMAKE_INCLUDE_PATH", "HOMEBREW_INCLUDE_PATHS"], openssl11.opt_include
    ENV.remove ["CMAKE_LIBRARY_PATH", "HOMEBREW_LIBRARY_PATHS"], openssl11.opt_lib

    args = %W[-DBUILD_TESTS=OFF -DQCA_PLUGINS_INSTALL_DIR=#{lib}/qt5/plugins]

    # Disable some plugins. qca-ossl, qca-cyrus-sasl, qca-logger,
    # qca-softstore are always built.
    %w[botan gcrypt gnupg nss pkcs11].each do |plugin|
      args << "-DWITH_#{plugin}_PLUGIN=ON"
    end

    # ensure opt_lib for framework install name and linking (can't be done via CMake configure)
    inreplace "src/CMakeLists.txt",
              /^(\s+)(INSTALL_NAME_DIR )("\$\{QCA_LIBRARY_INSTALL_DIR\}")$/,
             "\\1\\2\"#{opt_lib}\""

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"qcatool-qt5", "--noprompt", "--newpass=",
                              "key", "make", "rsa", "2048", "test.key"
  end
end

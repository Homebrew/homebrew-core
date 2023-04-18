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
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "a6f2d142c675f9f965deccca6b665a2ff4d467e897b1ab0469270b2eda5e711c"
    sha256 cellar: :any,                 arm64_monterey: "203a2967aed7022158e61d690a9387b115d8fecd30a63e74bf8f5bd9e279ea16"
    sha256 cellar: :any,                 arm64_big_sur:  "8ffa09c50b05bcdf5275861121d15a1ab774e8fc7a19b451ee28f6081bc9ca96"
    sha256 cellar: :any,                 ventura:        "08e0360669c0a54b0a2830f76b4dbe9dccbe25eb50189c0ccc1823043acd6427"
    sha256 cellar: :any,                 monterey:       "de974afccb56e853e81ea1526214a1d62bb81aa5997565608094178655a5a6ca"
    sha256 cellar: :any,                 big_sur:        "1b503104c0555f4a3511e1d67909e94d7be5c2158a3e1f710f9325a2134ca842"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "887c10b363a4aea88c20ccc44e50cb8f3fd5eee362712ac15465cf5d8dca795a"
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

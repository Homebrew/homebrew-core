class StellarCore < Formula
  desc "Backbone of the Stellar (XLM) network"
  homepage "https://www.stellar.org/"
  url "https://github.com/stellar/stellar-core.git",
      tag:      "v19.9.0",
      revision: "064a2787acb9e98c70567523785333581ee1ffa4"
  license "Apache-2.0"
  head "https://github.com/stellar/stellar-core.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8129d22d93e46d8c9ea82da75c1ec6dce1b83d14e3c4bacd4914a2038da18f6c"
    sha256 cellar: :any,                 arm64_monterey: "149524abfc11b26a0229d25171281c560976f8e224f5e3fa8a1771886ec7fed9"
    sha256 cellar: :any,                 arm64_big_sur:  "4eb1e01f05d71b22122917918159bc1f3d74b44516dbfc5b37a08e6fa96aa2c0"
    sha256 cellar: :any,                 ventura:        "8e9935ba1fdc58585edc2dc498ea6100d31b37bc7596e163c3347ff5f27483e6"
    sha256 cellar: :any,                 monterey:       "a79d4b93806d567ec47c00238c33e7a5692e689ad324347bf0194b34e40727d4"
    sha256 cellar: :any,                 big_sur:        "f5295edd13ecc0b84a18b54173f455abe2dcd8359fde1826d18c0fdf668a7287"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc3086ea6a0e78134195df046fc3acbab897f43c3a98bf5ce8bd25d7c45f949b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "bison" => :build # Bison 3.0.4+
  depends_on "libtool" => :build
  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "libpq"
  depends_on "libpqxx"
  depends_on "libsodium"
  depends_on macos: :catalina # Requires C++17 filesystem
  uses_from_macos "flex" => :build

  on_linux do
    depends_on "libunwind"
  end

  # https://github.com/stellar/stellar-core/blob/master/INSTALL.md#build-dependencies
  fails_with :gcc do
    version "7"
    cause "Requires C++17 filesystem"
  end

  def install
    system "./autogen.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-postgres"
    system "make", "install"
  end

  test do
    test_categories = %w[
      accountsubentriescount
      bucketlistconsistent
      topology
      upgrades
    ]
    system "#{bin}/stellar-core", "test",
      test_categories.map { |category| "[#{category}]" }.join(",")
  end
end

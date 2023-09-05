class StellarCore < Formula
  desc "Backbone of the Stellar (XLM) network"
  homepage "https://www.stellar.org/"
  url "https://github.com/stellar/stellar-core.git",
      tag:      "v19.13.0",
      revision: "c2599d62274931c11ea7f36c5ee9255a202f5739"
  license "Apache-2.0"
  head "https://github.com/stellar/stellar-core.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c95bf4271d570003292b1e90a0efaaf76242411919e57dcfcccf2bc8a6f0f0f8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ecb18b76406b98dff88b73dbb5c85bb1af410b7f7f14c1404ee595471db80b9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f192db5f9cff9cc26abeea9d3960045375aa08e0ccbb2b531d73c68f46b2002d"
    sha256 cellar: :any_skip_relocation, ventura:        "e62e24348445995eec6eb836136178ae4d5edbbff6ee05723d18a32724383d77"
    sha256 cellar: :any_skip_relocation, monterey:       "63e736ef959868f70edd80df0ca636471254751a43f18fdb5c513181e8384f63"
    sha256 cellar: :any_skip_relocation, big_sur:        "9246841664c152de198270a9c860edf9727249b3aca1d9568f5b59f4c4f07bde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b75fc976adbd374040412ef315080f6f6c7eed796115a8f23cffac7f414203a7"
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

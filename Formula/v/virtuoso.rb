class Virtuoso < Formula
  desc "High-performance object-relational SQL database"
  homepage "https://virtuoso.openlinksw.com/wiki/main/"
  url "https://github.com/openlink/virtuoso-opensource/releases/download/v7.2.11/virtuoso-opensource-7.2.11.tar.gz"
  sha256 "a15175be0e03887e20a776a0b21064fc2fae79beb2796d89bed5a91bf22b6256"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "18b1170c79ecd56db751ada64e0d9f35936a37a3f4e0a85a6d3b0635bb1034fd"
    sha256 cellar: :any,                 arm64_ventura:  "48493a2e269896d9feb3a4e2aa612121d0719ccc2911813fdd5e0ae7c30ef4fb"
    sha256 cellar: :any,                 arm64_monterey: "d0d5e7606b243bbc3da373aedeceb854924f439f91ec6d162d2b35993a0f66e9"
    sha256 cellar: :any,                 sonoma:         "68016908ca8ff05d59f08c7697d38f2945cade8f4eb868ea3cf0108d979d0c0e"
    sha256 cellar: :any,                 ventura:        "79fb51b61682d4c922853b38692ae388420d8f2abb4f4598cf278eab677ea9fe"
    sha256 cellar: :any,                 monterey:       "e83f497a56d041a4c759af571310236f7e7b51123c9618ddcea36bdde8e9c3f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28bf8569380e06f49990915265b17a941cc6494442b006fe8f3035bcb0dab7cf"
  end

  head do
    url "https://github.com/openlink/virtuoso-opensource.git", branch: "develop/7"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  # If gawk isn't found, make fails deep into the process.
  depends_on "gawk" => :build
  depends_on "openssl@3"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "gperf" => :build
  uses_from_macos "zlib"

  on_linux do
    depends_on "net-tools" => :build
  end

  conflicts_with "unixodbc", because: "both install `isql` binaries"

  skip_clean :la

  def install
    system "./autogen.sh" if build.head?
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--without-internal-zlib"
    system "make", "install"
  end

  def caveats
    <<~EOS
      NOTE: the Virtuoso server will start up several times on port 1111
      during the install process.
    EOS
  end

  test do
    system bin/"virtuoso-t", "+checkpoint-only"
  end
end

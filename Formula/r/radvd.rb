class Radvd < Formula
  desc "IPv6 Router Advertisement Daemon"
  homepage "https://radvd.litech.org/"
  url "https://github.com/radvd-project/radvd/releases/download/v2.21/radvd-2.21.tar.xz"
  sha256 "91df2ed7faca0716bbd726a17d6467ed92fcb2b6e45b57d9e619f9686ab99e1b"
  license "radvd"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d64fa035f9ba5b0ac270c6371632a00245fabaa7b1672da886973cfaed249ac3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e297345eb63b45c4a464c83887ed49cb664fa638a75bad620a2d64354c9fa66"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee4ac2ae84b7b542415c377ae60f33d36f6a36f9d8f5c9d917edefdda9b0f7bd"
    sha256 cellar: :any_skip_relocation, sonoma:        "e6dfb5b3126fc391a1388cddbd7e0077daa8944ef578f65ff5d1af87535696e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e1e42f18af7226393724e6a10156a9d9bfdcf39950bc20588bec1a1b9102e3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93ae07bba1442d28744ce243d88f0f6218e5374cf39478cfb58b4ed3ce965388"
  end

  head do
    url "https://github.com/radvd-project/radvd.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "libbsd"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"radvd.conf").write <<~EOS
      # Example config
      interface lo
      {
          AdvSendAdvert on;
          IgnoreIfMissing on;
          MinRtrAdvInterval 3;
          MaxRtrAdvInterval 10;
          AdvDefaultPreference low;
          AdvHomeAgentFlag off;
          prefix 2001:db8:1:0::/64
          {
              AdvOnLink on;
              AdvAutonomous on;
              AdvRouterAddr off;
          };
          prefix 0:0:0:1234::/64
          {
              AdvOnLink on;
              AdvAutonomous on;
              AdvRouterAddr off;
              Base6to4Interface ppp0;
              AdvPreferredLifetime 120;
              AdvValidLifetime 300;
          };
          route 2001:db0:fff::/48
          {
              AdvRoutePreference high;
              AdvRouteLifetime 3600;
          };
          RDNSS 2001:db8::1 2001:db8::2
          {
              AdvRDNSSLifetime 30;
          };
          DNSSL branch.example.com example.com
          {
              AdvDNSSLLifetime 30;
          };
      };
    EOS
    system sbin/"radvd", "-cC", testpath/"radvd.conf"
  end
end

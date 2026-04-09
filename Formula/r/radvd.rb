class Radvd < Formula
  desc "IPv6 Router Advertisement Daemon"
  homepage "https://radvd.litech.org/"
  url "https://github.com/radvd-project/radvd/releases/download/v2.20/radvd-2.20.tar.xz"
  sha256 "25d2960fb977ac35c45a8d85b71db22ed8af325db7dbf4a562fb03eab2848dcd"
  license "radvd"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d37d87602c7c0ca6e9b088215c1ca3a7bf01e8b62aa3be7b76ada6a9823f9078"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eec560f303de91f1806f46c6f54f4e51ec080f1dfc229fa569d2c0baab0711e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54485d998b57f3e9a199f53216530e0ca07e2da6d6a54872f5a2f4d1b4642a1b"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4f4a3af815645871d6eadf2574adad2450da398f767876acdbdd06fe04fb93b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad3ddab263acc0d7b55b37cb661117c8f1c72c4b3a87347bfef40e94552799b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4e8076563de9d02831b7ebfcedca64b085732111b2363ed46da86faeb382c51"
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

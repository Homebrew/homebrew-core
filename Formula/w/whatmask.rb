class Whatmask < Formula
  desc "Network settings helper"
  homepage "http://www.laffeycomputer.com/whatmask.html"
  url "https://web.archive.org/web/20170107110521/downloads.laffeycomputer.com/current_builds/whatmask/whatmask-1.2.tar.gz"
  sha256 "7dca0389e22e90ec1b1c199a29838803a1ae9ab34c086a926379b79edb069d89"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "a035d42b3734e84e406d28c3bcb1bddfb63f8551c4aaec6bfe3c9e049928e45e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2e13cae4bd5bb9c3c7c907b83a0f614f39b7170f7b46c28ce9f63785585f9c7d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "106997f1c14a81903f0c3078308437938af0fded133488f5c7de9fd90cc4cbdc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93e5d651f3376c9194a94a3afa5dc7860bbe55ac675339e6c2d9951f57d1b075"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a5bf6f569bef04d197a6eb0c097450e65dcb5082b65ecc82201e15eb873ae755"
    sha256 cellar: :any_skip_relocation, sonoma:         "8f66009407001342b73c1c144b306fdef7c0aa92affb9cd2e16729c199e30781"
    sha256 cellar: :any_skip_relocation, ventura:        "3a4ce45700a842a5db81df3403ddeac637a368cb6a0ddd514975fa9cb53381bb"
    sha256 cellar: :any_skip_relocation, monterey:       "dedc8e95cb750f18d6b8f03505387a17cc88753810f4e052b30b33126d9a8b8b"
    sha256 cellar: :any_skip_relocation, big_sur:        "55789adc6a9326b814965c6c0fcf41f912638f2e7d55d4167cbe404ec1a6938d"
    sha256 cellar: :any_skip_relocation, catalina:       "89a44972f8d27003b4c91f04a294f0be9a0d00628fb8db21faf46a55a0720cb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8bb2ab87b646751414698bd1bae28cbea1eecf7c147ae6a38fd02e9f3857a1c9"
  end

  deprecate! date: "2024-02-29", because: :repo_removed
  disable! date: "2025-03-04", because: :repo_removed

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    # The included ./configure file is too old to work with Xcode 12
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--mandir=#{man}", *std_configure_args
    system "make", "install"
  end

  test do
    assert_equal <<~EOS, shell_output("#{bin}/whatmask /24")

      ---------------------------------------------
             TCP/IP SUBNET MASK EQUIVALENTS
      ---------------------------------------------
      CIDR = .....................: /24
      Netmask = ..................: 255.255.255.0
      Netmask (hex) = ............: 0xffffff00
      Wildcard Bits = ............: 0.0.0.255
      Usable IP Addresses = ......: 254

    EOS
  end
end

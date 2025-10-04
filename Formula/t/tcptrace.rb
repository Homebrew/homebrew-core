class Tcptrace < Formula
  # The tcptrace.org site has a history of going down sometimes, which is why
  # we're using mirrors even though the first-party site may be available.
  desc "Analyze tcpdump output"
  homepage "https://web.archive.org/web/20210826120800/http://www.tcptrace.org/"
  url "https://www.mirrorservice.org/sites/distfiles.macports.org/tcptrace/tcptrace-6.6.7.tar.gz"
  mirror "https://distfiles.macports.org/tcptrace/tcptrace-6.6.7.tar.gz"
  sha256 "63380a4051933ca08979476a9dfc6f959308bc9f60d45255202e388eb56910bd"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "8d117c6645454b8a7d360ca644eff63f362abe2ce853b5d01733c67a49ca4373"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5391990c5db4c21d094d243368443f039990ed44da3d07e0a52b2f0922a3a6a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5a61be1025abf1a097a9353517bc3e3f861a3b443f42350937ca345a0befe648"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc1e3a00440e80a1b1ad88fc3ab0c872f47bd1f9d8fa9909add44144f3703be8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d27d973e94299d333fdd27c65e1260ee1c8ef12361a33e98a10cde109c781433"
    sha256 cellar: :any_skip_relocation, sonoma:         "1d23eeda4b2720acc9e15b49be4db33001e1c3fa3272d7046375f1ce8b19cc25"
    sha256 cellar: :any_skip_relocation, ventura:        "1be33a669bf94abdb6259a9a92b8c72027cd5ccc2054cf25c592ea9b5b34c123"
    sha256 cellar: :any_skip_relocation, monterey:       "82fa4c9aa859f61dd6f2ca36078b41b9994196d975a82b09b77529069a6fe195"
    sha256 cellar: :any_skip_relocation, big_sur:        "64787cc311c9da8d2090af5732efbe42f74c6dc5037b2b7ecb7055485603f20d"
    sha256 cellar: :any_skip_relocation, catalina:       "a1a61bd690da912afedd38f62eac7d5a1724c1ce68c68e7bcd8576e3fb86d956"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "048969e3fdf2e0c22e2e65b3a6548a0e5da8dd032ee770b32f8444e5ce007835"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7516135879ddee3a7a4271980b8485ac12c3b1826cb99ba23e9f6f849fda4ceb"
  end

  deprecate! date: "2024-04-18", because: :unmaintained
  disable! date: "2025-04-22", because: :unmaintained

  uses_from_macos "libpcap"

  on_linux do
    on_arm do
      depends_on "automake" => :build
    end
  end

  patch do
    url "https://github.com/msagarpatel/tcptrace/commit/f36b1567a5691d4c32489ab8493d8d4faaad3935.patch?full_index=1"
    sha256 "ee86790cc2c3cea38ab9d764b3bfbc6adf5f62ca6c33c590329c00429d0a9ef8"
  end

  def install
    # Workaround for ancient config files not recognizing aarch64 linux.
    if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      %w[config.guess config.sub].each do |fn|
        cp Formula["automake"].share/"automake-#{Formula["automake"].version.major_minor}"/fn, fn
      end
    end

    system "./configure", *std_configure_args
    system "make", "tcptrace"

    # don't install with owner/group
    inreplace "Makefile", "-o bin -g bin", ""
    system "make", "install", "BINDIR=#{bin}", "MANDIR=#{man}"
  end

  test do
    touch "dump"
    assert_match(/0 packets seen, 0 TCP packets/,
      shell_output("#{bin}/tcptrace dump"))
  end
end

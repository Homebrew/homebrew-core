class Tcpkali < Formula
  desc "High performance TCP and WebSocket load generator and sink"
  homepage "https://web.archive.org/web/20230303212249/https://github.com/satori-com/tcpkali"
  url "https://www.mirrorservice.org/sites/distfiles.macports.org/tcpkali/tcpkali-1.1.1.tar.gz"
  sha256 "a9a15a1703fc4960360a414ee282d821a7b42d4bbba89f9e72a796164ff69598"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "b35b2a69212122e9fe05744632f7e9d4fb424881dc430216559df87f797d4239"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "d3356d233dace7efe54b216d5ba97ed31a4ad7e800bb94ad5bc078dcdda8e7a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e39e3dddac6717a918e86cb86f552ccc71c2a828b361599083a0d36fa3e79780"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a4e360c9b9f4e392e429075847cf3d4f02d0318668d19d5745a7f0108c381330"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1da7a44e7f3a40440cbb5ac8fa5fde5156c22125080daf5c6afc884b3f8dc264"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7e7b45ed05cf7d7ad1dde75394b670e192c217cdfe98012e8da514cf6717d64a"
    sha256 cellar: :any_skip_relocation, sonoma:         "647259f0136c276ba922e9b437821f4f6b7c6211532827fe70fb363bca4cf2ac"
    sha256 cellar: :any_skip_relocation, ventura:        "e3a2e0de9e4081e5f2720aec73737040ad1449b1d69d4ce7fbd1cad1940f4c11"
    sha256 cellar: :any_skip_relocation, monterey:       "4fb40f82ea3e44a7903dea3e1ef6a950833368346a5810a91b393b7537ec8bd6"
    sha256 cellar: :any_skip_relocation, big_sur:        "6496fe2ab336a75fecc905017ea8886c67dff3e13139b37474e6f500eb98e0fa"
    sha256 cellar: :any_skip_relocation, catalina:       "01bd403a6b94827f4670877d1e36ee4c439f708d84d364584e5b1538837e72d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "a21cdba0e1d2863bb691ab0b2a6b416f801b38236a399a3bd8d6cfc67762f539"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae1230bcf9879d1d8f09d5e0a3b80c9baf7f59c2bfa77a296a06ed6a821d5be7"
  end

  deprecate! date: "2025-03-19", because: :repo_removed

  uses_from_macos "bison" => :build
  uses_from_macos "ncurses"

  def install
    args = []
    if OS.linux?
      inreplace "src/tcpkali_syslimits.c", "<sys/sysctl.h>", "<linux/sysctl.h>"
      # Help old config scripts identify arm64 linux
      args << "--build=aarch64-unknown-linux-gnu" if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
    end

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"tcpkali", "-l1237", "-T0.5", "127.1:1237"
  end
end

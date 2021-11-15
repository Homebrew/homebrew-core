class Zsxd < Formula
  desc "Zelda Mystery of Solarus XD"
  homepage "https://www.solarus-games.org/en/games/the-legend-of-zelda-mystery-of-solarus-xd"
  url "https://gitlab.com/solarus-games/zsxd/-/archive/v1.12.2/zsxd-v1.12.2.tar.bz2"
  sha256 "656ac2033db2aca7ad0cd5c7abb25d88509b312b155ab83546c90abbc8583df1"
  head "https://gitlab.com/solarus-games/zsxd.git", branch: "dev"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee42ed381fd488a0e538e30eeff539346f71c0822fcc899907792fc4acc5988a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4092f599ecb1631608fe3a5109006480d6797bee0ec8b4cd4878b451f4400720"
    sha256 cellar: :any_skip_relocation, monterey:       "5641638453928b8d7dc434051961417e5c3e768c06fc35f9879737640027ece3"
    sha256 cellar: :any_skip_relocation, big_sur:        "ccae47d22a42e29f9d5d37fdd0be7cfa8f451d3b0f42d2db2b933f6a7ae1d129"
    sha256 cellar: :any_skip_relocation, catalina:       "aabcc393aae8f00a45ffa24d959ff57a6023caace90a815f8107c579e113b87e"
    sha256 cellar: :any_skip_relocation, mojave:         "8b6e336bd61f16c620ab8323ccd15dfc35cf1665c71799a838c4436fefd561b0"
    sha256 cellar: :any_skip_relocation, high_sierra:    "fa0726547d624647bd7453100b6e2221ce0ec9174e0cd43275844b09aefb6c0d"
  end

  depends_on "cmake" => :build
  depends_on "solarus"

  def install
    system "cmake", ".", *std_cmake_args, "-DSOLARUS_INSTALL_DATADIR=#{share}"
    system "make", "install"
  end

  test do
    system Formula["solarus"].bin/"solarus-run", "-help"
    system "/usr/bin/unzip", pkgshare/"data.solarus"
  end
end

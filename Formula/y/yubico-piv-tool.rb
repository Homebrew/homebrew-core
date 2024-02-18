class YubicoPivTool < Formula
  desc "Command-line tool for the YubiKey PIV application"
  homepage "https://developers.yubico.com/yubico-piv-tool/"
  url "https://developers.yubico.com/yubico-piv-tool/Releases/yubico-piv-tool-2.5.1.tar.gz"
  sha256 "4262df01eec5c5ef942be9694db5bceac79f457e94879298a4934f6b5e44ff5f"
  license "BSD-2-Clause"

  livecheck do
    url "https://developers.yubico.com/yubico-piv-tool/Releases/"
    regex(/href=.*?yubico-piv-tool[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "79556da52885390c09319a369dc4d4ab1d5662bfe3d5dd69d0e314b5893723ff"
    sha256 cellar: :any,                 arm64_ventura:  "f03d008f58c0dfaf577531c598379bd32688b14de9d7a4f5f771929a7b2fa877"
    sha256 cellar: :any,                 arm64_monterey: "19e9067008fb1b9578921a91b9f07bc1eecf768eac97d7fc60b7b83b70e4545a"
    sha256 cellar: :any,                 sonoma:         "6a25e67d9ccf17465739ffb9ec01700e4a0823a90df385f243cfffaea2049c63"
    sha256 cellar: :any,                 ventura:        "525bca1b009a00e0b8176feb9528977e011b09ed39c7a39bf076faf15bfc3369"
    sha256 cellar: :any,                 monterey:       "c7bdcf7c7fa235ed27a2d773ff506d688f40f7561cb294fdd028384be6dce211"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "286f4a3d11d67b84a27f441ae8a3f796babec3a7b723f0a19caeed3f82889fe7"
  end

  depends_on "check" => :build
  depends_on "cmake" => :build
  depends_on "gengetopt" => :build
  depends_on "help2man" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "check"
  depends_on "openssl@3"
  depends_on "pcsc-lite"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DCMAKE_C_FLAGS=-I#{Formula["pcsc-lite"].opt_include}/PCSC"
      system "make", "install"
    end
  end

  test do
    assert_match "yubico-piv-tool #{version}", shell_output("#{bin}/yubico-piv-tool --version")
  end
end

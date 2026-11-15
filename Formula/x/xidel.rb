class Xidel < Formula
  desc "XPath/XQuery 3.0, JSONiq interpreter to extract data from HTML/XML/JSON"
  homepage "https://www.videlibri.de/xidel.html"
  url "https://github.com/benibela/xidel/releases/download/Xidel_0.9.8/xidel-0.9.8.src.tar.gz"
  sha256 "72b5b1a2fc44a0a61831e268c45bc6a6c28e3533b5445151bfbdeaf1562af39c"
  license "GPL-3.0-or-later"
  revision 2

  livecheck do
    url :stable
    regex(/^(?:Xidel[-_])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "1d1553e622c0ec71255940058acf72941ac2d1eae5337daa46dad9e1ef961612"
    sha256 cellar: :any, arm64_tahoe:       "1d1553e622c0ec71255940058acf72941ac2d1eae5337daa46dad9e1ef961612"
    sha256 cellar: :any, arm64_sequoia:     "6ecc8a2b6d82ad2eb7d2752521cdc0d5bde48e2d30bb86a62ad71a8580d2ace5"
    sha256 cellar: :any, arm64_linux:       "b3df31b4cdf8eca1eb55e1e5b95a7a42930a969d572783987e09f4cd67251531"
    sha256 cellar: :any, x86_64_linux:      "fa6ba1d404080260b5695594f7f49c99ce8b35d21494da7bb5240d227c946335"
  end

  head do
    url "https://github.com/benibela/xidel.git", branch: "master"

    # https://github.com/benibela/xidel/blob/master/.github/download-dependencies.sh
    resource "flre" do
      url "https://github.com/benibela/flre.git", branch: "master"
    end
    resource "internettools" do
      url "https://github.com/benibela/internettools.git", branch: "master"
    end
    resource "pasdblstrutils" do
      url "https://github.com/BeRo1985/pasdblstrutils.git", branch: "master"
    end
    resource "rcmdline" do
      url "https://github.com/benibela/rcmdline.git", branch: "master"
    end
    resource "synapse" do
      url "https://github.com/benibela/ararat-synapse.git", branch: "master"
    end
  end

  depends_on "fpc" => :build
  depends_on "openssl@4"

  deny_network_access!

  def install
    resources.each do |r|
      r.stage buildpath/"import"/r.name
    end

    cd "programs/internet/xidel" if build.stable?
    inreplace "build.sh", "$fpc ", "$fpc -k-rpath -k#{sh_quote formula_opt_lib("openssl@4").to_s} "
    system "./build.sh"
    bin.install "xidel"
    man1.install "meta/xidel.1"
  end

  test do
    assert_equal "123\n", shell_output("#{bin}/xidel -e 123")
  end
end

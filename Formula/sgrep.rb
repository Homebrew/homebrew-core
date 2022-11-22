class Sgrep < Formula
  desc "Search SGML, XML, and HTML"
  homepage "https://www.cs.helsinki.fi/u/jjaakkol/sgrep.html"
  url "https://www.cs.helsinki.fi/pub/Software/Local/Sgrep/sgrep-1.94a.tar.gz"
  mirror "https://fossies.org/linux/misc/old/sgrep-1.94a.tar.gz"
  sha256 "d5b16478e3ab44735e24283d2d895d2c9c80139c95228df3bdb2ac446395faf9"

  # The current formula version (1.94a) is an alpha version, so this regex
  # has to allow for unstable versions. If/when a new stable version after 0.99
  # ever appears, the optional `[a-z]?` part of this regex should be removed,
  # so it will only match stable versions.
  livecheck do
    url "https://www.cs.helsinki.fi/pub/Software/Local/Sgrep/"
    regex(/href=.*?sgrep[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6492d756d61b8cacca30d42da39a0d039a3d9e90ae03a7ed7fa5461970dc4af4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "213de82d5aff5377df50fbe7cedcaa3e099feb2ccee33c7f9dbc35ff4bfb8c7f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "775257fda7135fce998eafe41e1c39f32da44a2c5440dd205ff0a7801e6ef9f9"
    sha256 cellar: :any_skip_relocation, ventura:        "a6aac3155b62fd7feed928b2c57f9b417ee102688352b573c9e39122e19c463a"
    sha256 cellar: :any_skip_relocation, monterey:       "192436239783803b977e5804d989dc67f7760d87ed7831bb3c30dae5146204cf"
    sha256 cellar: :any_skip_relocation, big_sur:        "fedcff86ec032617015882c5729298bbe1f1fcbda14cdde6167b00ae2af586b8"
    sha256 cellar: :any_skip_relocation, catalina:       "29e528a52ae36131ded52bb08d9cf9b12b1455fbc715f7b7bbd3b97f637862e5"
    sha256 cellar: :any_skip_relocation, mojave:         "bfb1f484dd474727fec463b1b90ffe7250f5c82e0e65bec96903e38f6e0a8e48"
    sha256 cellar: :any_skip_relocation, high_sierra:    "a243589e79a4cde4f7bba21ec618e3c323c049589707bde6e2c20c4bf1014464"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b9d7e430b35750659c93cfd9308b5cf32211eb19b79a8ee3bf0c0b62ef2712b"
  end

  uses_from_macos "m4"

  on_arm do
    # Added automake as a build dependency to update config files for ARM support.
    depends_on "automake" => :build
  end

  def install
    if Hardware::CPU.arm?
      # Workaround for ancient config files not recognizing aarch64 macos.
      %w[config.guess config.sub].each do |fn|
        cp Formula["automake"].share/"automake-#{Formula["automake"].version.major_minor}"/fn, fn
      end
    end

    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--datadir=#{pkgshare}"
    system "make", "install"
  end

  test do
    input = test_fixtures("test.eps")
    assert_equal "2", shell_output("#{bin}/sgrep -c '\"mark\"' #{input}").strip
  end
end

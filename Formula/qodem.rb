class Qodem < Formula
  desc "Terminal emulator and BBS client"
  homepage "https://qodem.sourceforge.io/"
  url "https://github.com/klamonte/qodem/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "84aecd322839c615c6f465128ea3231163067606704f19ffa50e5d3481b6ff01"
  license :public_domain

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "230b60c0f6dbd68eb6842acc073e21b0fb2bb5e4e47a8f37b2fd812980849c7f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0edd8a307de97c0844df4940c87ea88cfe68e5b41ca55e6c6d67f4b024b31477"
    sha256 cellar: :any_skip_relocation, monterey:       "ded91d17b85bfa34b3cd3eb01a338f19ed91711a2c4fdea71d5543cc3953c2ab"
    sha256 cellar: :any_skip_relocation, big_sur:        "ac2537f733ed6952656aec3016302414b37166b64b2d89836f17354008276f73"
    sha256 cellar: :any_skip_relocation, catalina:       "14491121c60a5368cf41e4cab4df43bd918f31342f8aedf7e43241a3e49b22b7"
    sha256 cellar: :any_skip_relocation, mojave:         "e5b1c53c02b9111a447d2eae8d74231ba3f9374ba7775215bd1559eb1b326e61"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--disable-gpm",
                          "--disable-sdl",
                          "--disable-serial",
                          "--disable-upnp",
                          "--disable-x11"
    system "make", "install"
  end

  test do
    system "#{bin}/qodem", "--exit-on-completion", "--capfile", testpath/"qodem.out", "uname"
    assert_match OS.kernel_name, File.read(testpath/"qodem.out")
  end
end

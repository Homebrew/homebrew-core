class Recode < Formula
  desc "Convert character set (charsets)"
  homepage "https://github.com/rrthomas/recode"
  url "https://github.com/rrthomas/recode/releases/download/v3.7.9/recode-3.7.9.tar.gz"
  sha256 "e4320a6b0f5cd837cdb454fb5854018ddfa970911608e1f01cc2c65f633672c4"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "c116a7d29975a1649b79f96067de047149050454d11fb09146066e617fadd13f"
    sha256 cellar: :any, big_sur:       "6d53af7b188693ffa022df92beea56d3963482c8206d1608e25d47ca5bd88848"
    sha256 cellar: :any, catalina:      "367ab01690803d0270de4734faf1ef5175c2e3df7528b9f64bdcc0c1a78f1668"
    sha256 cellar: :any, mojave:        "34d0491040e447e2a0cbe304d021ea82be00040a7c5533ac82e43907771636b1"
  end

  depends_on "libtool" => :build
  depends_on "python@3.9" => :build
  depends_on "gettext"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/recode --version")
  end
end

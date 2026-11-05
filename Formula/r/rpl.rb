class Rpl < Formula
  desc "Text replacement utility"
  homepage "https://github.com/rrthomas/rpl"
  url "https://github.com/rrthomas/rpl/releases/download/v2.1.2/rpl-2.1.2.tar.gz"
  sha256 "7994ef8663a51779ab1fb3a730cf2ae6cda81cc905b6db9ae0e858f63cb8b3e1"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "698786e815561b07c7cb3f2af12b7fd255fdc78f4ed7860b7e52b8b8e8d02b44"
    sha256 cellar: :any, arm64_tahoe:       "78f96d5d14af1194b4bfdc24d06d03698a8c94952d0c5bd2900d3522fc9d80a2"
    sha256 cellar: :any, arm64_sequoia:     "6ac0ebd923df28be08cbd2278b91979f8118c01ab8b0d34446cdd8cdab6092b6"
    sha256 cellar: :any, arm64_linux:       "69cb6b065c427702e5a329a494ad74c1fe21fb0e535d93256b33afe46268ec3e"
    sha256 cellar: :any, x86_64_linux:      "34282ca2c648a99bd56fd8af6d94f00dbf21534ad9e9cbbcaf33ed4990dc686b"
  end

  depends_on "help2man" => :build
  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "pcre2"
  depends_on "uchardet"

  on_macos do
    depends_on "gettext"
  end

  deny_network_access!

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test").write "I like water."

    system bin/"rpl", "-v", "water", "beer", "test"
    assert_equal "I like beer.", (testpath/"test").read
  end
end

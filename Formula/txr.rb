class Txr < Formula
  desc "Lisp-like programming language for convenient data munging"
  homepage "https://www.nongnu.org/txr/"
  url "http://www.kylheku.com/cgit/txr/snapshot/txr-285.tar.bz2"
  sha256 "708d708f128f8af4d7c024ae865eac22e464ebc64152c3964e3424b469a63fa3"
  license "BSD-2-Clause"

  livecheck do
    url "http://www.kylheku.com/cgit/txr"
    regex(/href=.*?txr[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9ca090c143be80224d3f6a828adcb570bae4848a0a5f83772aba2ba2915979f5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "badf816aa9a1928e1a797fbe6b28f52374decf826e7c19ae3190df3b48ccad46"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c328de1d8a6bd77946944848a128fbd1b92981ba69d387815cda40e2013e1edd"
    sha256 cellar: :any_skip_relocation, ventura:        "cbeab8c2950206d978f035a7e0e3acb2706035ba3a5afa07197b4090fa28e209"
    sha256 cellar: :any_skip_relocation, monterey:       "cb0abd319c7bf709db481254082d4f5c300740a273376cd12af5f6de6a57b12b"
    sha256 cellar: :any_skip_relocation, big_sur:        "c42b438aa18baac6f0094a933fed4f6d73d48dcf2d256837332958e2baa38973"
  end

  depends_on "pkg-config" => :build
  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "libffi", since: :catalina

  def install
    system "./configure", "--prefix=#{prefix}", "--inline=static inline"
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "3", shell_output("#{bin}/txr -p '(+ 1 2)'").chomp
  end
end

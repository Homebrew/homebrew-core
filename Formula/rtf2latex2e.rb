class Rtf2latex2e < Formula
  desc "RTF-to-LaTeX translation"
  homepage "https://rtf2latex2e.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/rtf2latex2e/rtf2latex2e-unix/2-2/rtf2latex2e-2-2-3.tar.gz"
  version "2.2.3"
  sha256 "7ef86edea11d5513cd86789257a91265fc82d978541d38ab2c08d3e9d6fcd3c3"

  livecheck do
    url :stable
    regex(%r{url=.*?/rtf2latex2e[._-]v?(\d+(?:[.-]\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_ventura:  "12f88e9bf99968693672ded4a3784e42558e15895be581c13df04a7c99e978d4"
    sha256 arm64_monterey: "dad0a2da5ef80b23fc0dfef461a75c8df8aea2d8c1fbe2714c0c1bc9cbf8f2fc"
    sha256 arm64_big_sur:  "35639bec913a1d60de52ac3d15d633bc17878c06829a1e5338272bae0f2399cd"
    sha256 ventura:        "6c9d8dd73ea187545b5b6400918c8f2f493e32584c4ac01e9b035738c658fe66"
    sha256 monterey:       "3a88828b56f1fa396ee82d9b8e40f15631512a587b57489d9513a773bea157ac"
    sha256 big_sur:        "c0348eb7e801057a74bedb8665b51ab62d9239ee7d6fff51d2c094ce092b6e6e"
    sha256 catalina:       "c7c3d46cf3f0b3a18dcb01aa9e1f2be4573f236e52f466d78eda4d659084e5bf"
    sha256 mojave:         "bed54dc624378c20df3c352618645058a3ae3956d9cb5811af63836ffaa2dd10"
    sha256 high_sierra:    "b31c9387003920d4c27cb846da71203d69711638ed284825861a12247eeabca9"
    sha256 sierra:         "bbab54edbb07cbc3e16da33bdb0bd68258a330a3d1e2fceb175d1b753e6b81de"
    sha256 el_capitan:     "0aa7144c74e8af3a935a87c2b9c822581c38566e24351a50ae601bbedca4aec3"
    sha256 x86_64_linux:   "be77a066d018ead2d07e0bdb5e535f597e2ccea5659a505a271efe017a16fd94"
  end

  def install
    system "make", "install", "prefix=#{prefix}", "CC=#{ENV.cc}"
  end

  def caveats
    <<~EOS
      Configuration files have been installed to:
        #{opt_pkgshare}
    EOS
  end

  test do
    (testpath/"test.rtf").write <<~'EOS'
      {\rtf1\ansi
      {\b hello} world
      }
    EOS
    system bin/"rtf2latex2e", "-n", "test.rtf"
    assert_match "textbf{hello} world", File.read("test.tex")
  end
end

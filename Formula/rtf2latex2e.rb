class Rtf2latex2e < Formula
  desc "RTF-to-LaTeX translation"
  homepage "https://rtf2latex2e.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/rtf2latex2e/rtf2latex2e-unix/2-2/rtf2latex2e-2-2-3.tar.gz"
  version "2.2.3"
  sha256 "7ef86edea11d5513cd86789257a91265fc82d978541d38ab2c08d3e9d6fcd3c3"

  bottle do
    sha256 "c7c3d46cf3f0b3a18dcb01aa9e1f2be4573f236e52f466d78eda4d659084e5bf" => :catalina
    sha256 "bed54dc624378c20df3c352618645058a3ae3956d9cb5811af63836ffaa2dd10" => :mojave
    sha256 "b31c9387003920d4c27cb846da71203d69711638ed284825861a12247eeabca9" => :high_sierra
    sha256 "bbab54edbb07cbc3e16da33bdb0bd68258a330a3d1e2fceb175d1b753e6b81de" => :sierra
    sha256 "0aa7144c74e8af3a935a87c2b9c822581c38566e24351a50ae601bbedca4aec3" => :el_capitan
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

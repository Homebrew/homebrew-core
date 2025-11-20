class Rtf2latex2e < Formula
  desc "RTF-to-LaTeX translation"
  homepage "https://rtf2latex2e.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/rtf2latex2e/rtf2latex2e-unix/2-2/rtf2latex2e-2-2-3.tar.gz"
  version "2.2.3"
  sha256 "7ef86edea11d5513cd86789257a91265fc82d978541d38ab2c08d3e9d6fcd3c3"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/rtf2latex2e[._-]v?(\d+(?:[.-]\d+)+)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "7b023787b6ca5b67c6aed5da197e586269857f3d0ca369d7bcb1f8104876def6"
    sha256 arm64_sequoia:  "831e4f4beb242fc95b2fa79b14e9cd22cedf31675de00c15e39a63445a2f59cc"
    sha256 arm64_sonoma:   "20d8b8da32f9ff8602f0cbe64dec244a89825507fdfd805bb1d2d6cfc75a85d2"
    sha256 arm64_ventura:  "12f88e9bf99968693672ded4a3784e42558e15895be581c13df04a7c99e978d4"
    sha256 arm64_monterey: "dad0a2da5ef80b23fc0dfef461a75c8df8aea2d8c1fbe2714c0c1bc9cbf8f2fc"
    sha256 arm64_big_sur:  "35639bec913a1d60de52ac3d15d633bc17878c06829a1e5338272bae0f2399cd"
    sha256 sonoma:         "8ed26391c02189f76bd07fa5fb453ac44dcba86f7991884fd9f8c43555e81709"
    sha256 ventura:        "6c9d8dd73ea187545b5b6400918c8f2f493e32584c4ac01e9b035738c658fe66"
    sha256 monterey:       "3a88828b56f1fa396ee82d9b8e40f15631512a587b57489d9513a773bea157ac"
    sha256 big_sur:        "c0348eb7e801057a74bedb8665b51ab62d9239ee7d6fff51d2c094ce092b6e6e"
    sha256 catalina:       "c7c3d46cf3f0b3a18dcb01aa9e1f2be4573f236e52f466d78eda4d659084e5bf"
    sha256 arm64_linux:    "2616c236d487e2a2ee9da2d9a858433363de29e8c4f15d8d29785a68ebde0244"
    sha256 x86_64_linux:   "be77a066d018ead2d07e0bdb5e535f597e2ccea5659a505a271efe017a16fd94"
  end

  def install
    # Workaround for arm64 linux. Upstream isn't actively maintained
    ENV.append_to_cflags "-fsigned-char" if OS.linux? && Hardware::CPU.arm?

    # Workaround for newer Clang
    ENV.append "CC", "-Wno-implicit-int" if DevelopmentTools.clang_build_version >= 1403

    # Work around failure from GCC 10+ using default of `-fno-common`
    # multiple definition of `eqn_start_inline'; src/eqn.o:(.bss+0x18): first defined here
    ENV.append_to_cflags "-fcommon" if OS.linux?

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

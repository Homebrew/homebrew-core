class RegexOpt < Formula
  desc "Perl-compatible regular expression optimizer"
  homepage "https://bisqwit.iki.fi/source/regexopt.html"
  url "https://bisqwit.iki.fi/src/arch/regex-opt-1.2.4.tar.gz"
  sha256 "128c8ba9570b1fd8a6a660233de2f5a4022740bc5ee300300709c3894413883f"

  bottle do
    cellar :any_skip_relocation
    sha256 "a7f1e5b8eb46eb11388c8eed77f24d547c1448b228cf7ca35f2e5cb0145bab88" => :high_sierra
    sha256 "110befc20e434b5d6294d9f3ad2592cae2bfaedec4e8fa1c3cff7265e83acc27" => :sierra
    sha256 "7c3d9a1af7a3797bd556cc66402c558cfaaffce4d956094fcdd4fcd1b3a4bc3c" => :el_capitan
  end

  def install
    # regex-opt uses _Find_first() in std::bitset, which is a
    # nonstandard extension supported in libstdc++ but not libc++
    # See: https://lists.w3.org/Archives/Public/www-archive/2006Jan/0002.html
    ENV.libstdcxx if ENV.compiler == :clang

    system "make", "CC=#{ENV.cc}", "CXX=#{ENV.cxx}"
    bin.install "regex-opt"
  end

  test do
    system "#{bin}/regex-opt"
  end
end

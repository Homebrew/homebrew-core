class RegexOpt < Formula
  desc "Perl-compatible regular expression optimizer"
  homepage "http://bisqwit.iki.fi/source/regexopt.html"
  url "http://bisqwit.iki.fi/src/arch/regex-opt-1.2.3.tar.gz"
  sha256 "e0a4e4fea7f46bd856ce946d5a57f2b19d742b5d6f486e054e4c51b1f534b87e"

  bottle do
    cellar :any_skip_relocation
    sha256 "6450d5a7ab5cc7a19e14753aa797e3044b7f0f29dba2cc22c4db32c2706d439d" => :sierra
    sha256 "3f9bdf79820441d3a0941a8cb17b9d2c4f512b9e0fbdc36560681c3534e3615a" => :el_capitan
    sha256 "01d8af104a70bc0bcf9c9fb1b93b0e4f3a7d08aaadd367e34ec223c38a00d58c" => :yosemite
    sha256 "08ac62a2ea7522fb62f915bad274e2693b8e587e8266d705f2fa210c3405c19d" => :mavericks
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

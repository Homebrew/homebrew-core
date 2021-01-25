class SsllabsScan < Formula
  desc "This tool is a command-line client for the SSL Labs APIs"
  homepage "https://github.com/ssllabs/ssllabs-scan/"
  url "https://github.com/ssllabs/ssllabs-scan/archive/v1.5.0.tar.gz"
  sha256 "51c52e958d5da739910e9271a3abf4902892b91acb840ea74f5c052a71e3a008"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "bedc2ae76ea62f469af8ca941f894016b053edd0c598e4845bcbe95e73c344a3" => :big_sur
    sha256 "445a6d45341a1e6bf831f04eb00e87ca5e39df27685af0da5504e64e3fbb1efb" => :arm64_big_sur
    sha256 "01c7e2503e8793f79149a3115dffff286ab0db876ccbfe6d8bb11ed54f27ba38" => :catalina
    sha256 "eb44e540aba0e6a209ab3820a168184f39ddd470673093c7a3dc87a0e70eab42" => :mojave
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w", "ssllabs-scan-v3.go"
  end

  def caveats
    <<~EOS
      By installing this package you agree to the Terms and Conditions defined by Qualys.
      You can find the terms and conditions at this link:
         https://www.ssllabs.com/about/terms.html

      If you do not agree with those you should uninstall the formula.
    EOS
  end

  test do
    system "#{bin}/ssllabs-scan", "-grade", "-quiet", "-usecache", "ssllabs.com"
  end
end

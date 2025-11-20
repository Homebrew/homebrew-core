class SsllabsScan < Formula
  desc "This tool is a command-line client for the SSL Labs APIs"
  homepage "https://www.ssllabs.com/projects/ssllabs-apis/"
  url "https://github.com/ssllabs/ssllabs-scan/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "51c52e958d5da739910e9271a3abf4902892b91acb840ea74f5c052a71e3a008"
  license "Apache-2.0"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "0f8a61fd15b012c3792bdbcdc8229833e8d9d4f9e8b009e3f88d7e8a477ac111"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "d639a0a8a695a23b9554d15893132fac16c35675d8e84651696f9b2f1a7ab1a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bdd94308ce1a118aefc4cc9d6e9c4a349d5b85c256747732dbf1d1af91930428"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1d77c5c9f38fe3c137fd3b3da69c56a0b5a1015f94eb5526a6b4a685d72fb4c4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "21c59e50196234b6cabed14cd45c4e905dd8bf38f77491431c2da7427c3ede5e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "445a6d45341a1e6bf831f04eb00e87ca5e39df27685af0da5504e64e3fbb1efb"
    sha256 cellar: :any_skip_relocation, sonoma:         "1448551689011cb673df66494349bc792bd5654596bd83e8ff2938912e60a157"
    sha256 cellar: :any_skip_relocation, ventura:        "dfda1df2744e990f78acec1d005f5c214b569c9a2fdcfcb223e515c5c1954858"
    sha256 cellar: :any_skip_relocation, monterey:       "9cd0b9e4f6980fb49897f09adb167a5a7be7f7d4405f261829b713cb262e713a"
    sha256 cellar: :any_skip_relocation, big_sur:        "bedc2ae76ea62f469af8ca941f894016b053edd0c598e4845bcbe95e73c344a3"
    sha256 cellar: :any_skip_relocation, catalina:       "01c7e2503e8793f79149a3115dffff286ab0db876ccbfe6d8bb11ed54f27ba38"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "edd29f50b8ff77077f310d961a60a6e58cd157e80925e58f586a020f90a56e67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9298cfa3c9eb7b7effb0f924f9998e63406d3bfacd4b4df9785a0371138699e2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "ssllabs-scan-v3.go"
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
    system bin/"ssllabs-scan", "-grade", "-quiet", "-usecache", "ssllabs.com"
  end
end

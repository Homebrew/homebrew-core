class SsllabsScan < Formula
  desc "This tool is a command-line client for the SSL Labs APIs"
  homepage "https://github.com/ssllabs/ssllabs-scan/"
  url "https://github.com/ssllabs/ssllabs-scan/archive/v1.4.0.tar.gz"
  sha256 "a7d5fad92649172ca4b190f481172b602aa1ae103d14dd1f1951ee250d382eec"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "347219010c359655ec30f056c47a7a3e0d91e80fabfc5655f141c3f20dc980d5" => :mojave
    sha256 "bee10085983dac1bcd9d46773ea7e2fc50ec3c8c54442d8ef50cb1683ab9175c" => :high_sierra
    sha256 "e527081f119ba004e06bba763d780d676df38bacd28b482bbeae64cbf43e4aea" => :sierra
    sha256 "f541615737e69900d1a141af1872bc983cdeb94cd28016dfa8c3f5ba0f11d8c0" => :el_capitan
    sha256 "18b509cec2507dd9a50aedcb618a8069ecbecc765cd31791381765c596702932" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    system "make", "build"
    bin.install "ssllabs-scan"
  end

  def caveats; <<~EOS
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

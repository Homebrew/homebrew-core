class Svgcleaner < Formula
  desc "Cleans your SVG files by removing unnecessary data"
  homepage "https://github.com/RazrFalcon/svgcleaner"
  url "https://github.com/RazrFalcon/svgcleaner/archive/v0.9.5.tar.gz"
  sha256 "dcf8dbc8939699e2e82141cb86688b6cd09da8cae5e18232ef14085c2366290c"
  license "GPL-2.0"
  head "https://github.com/RazrFalcon/svgcleaner.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a7d1ee246dc48406e261ac3ab4043f35f653d3973d738aecde6c9bf9fdcf85c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9cba5273a6c44bc5257f11a1de3d7302872396d184aaa05128ad3a0903b34735"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "af01e1a22b3edaaf33aeca10080cd50ba097531e72cde15a0ced468758df8aa4"
    sha256 cellar: :any_skip_relocation, ventura:        "8645b2e59ac28b20504c4a9b3b19c72da2fa7a4248218ee6a3c128d872ed755e"
    sha256 cellar: :any_skip_relocation, monterey:       "06aabee9050ad9a8882623cb4f2b20e537e7c56387eb428fa7e7800f513f14fb"
    sha256 cellar: :any_skip_relocation, big_sur:        "9d2c263f4774a4c646576e2beb78adbddc67d966d8fad9fcbe43d5cae8b737d7"
    sha256 cellar: :any_skip_relocation, catalina:       "13ccddae8456f69bda812f89ab5657f23f27940a8b9e32a13f34e0d5f41f7ae8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ad0a9020b3aa287c3d3ad908c7cbc625aceef02a0cfc559d817a6b1f2acc064"
  end

  deprecate! date: "2021-12-11", because: :repo_archived

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"in.svg").write <<~EOS
      <?xml version="1.0" encoding="UTF-8" standalone="no"?>
      <svg
         xmlns="http://www.w3.org/2000/svg"
         version="1.1"
         width="150"
         height="150">
        <rect
           width="90"
           height="90"
           x="30"
           y="30"
           style="fill:#0000ff;fill-opacity:0.75;stroke:#000000"/>
      </svg>
    EOS
    system bin/"svgcleaner", "in.svg", "out.svg"
  end
end

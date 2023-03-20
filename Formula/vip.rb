class Vip < Formula
  desc "Program that provides for interactive editing in a pipeline"
  homepage "https://www.cs.duke.edu/~des/vip.html"
  url "https://www.cs.duke.edu/~des/scripts/vip"
  version "19971113"
  sha256 "171278e8bd43abdbd3a4c35addda27a0d3c74fc784dbe60e4783d317ac249d11"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cd1eaee76c43cbe5384907f794d619db9b4d044eb54e223e0666e4da73f007e8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd1eaee76c43cbe5384907f794d619db9b4d044eb54e223e0666e4da73f007e8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cd1eaee76c43cbe5384907f794d619db9b4d044eb54e223e0666e4da73f007e8"
    sha256 cellar: :any_skip_relocation, ventura:        "cd1eaee76c43cbe5384907f794d619db9b4d044eb54e223e0666e4da73f007e8"
    sha256 cellar: :any_skip_relocation, monterey:       "cd1eaee76c43cbe5384907f794d619db9b4d044eb54e223e0666e4da73f007e8"
    sha256 cellar: :any_skip_relocation, big_sur:        "cd1eaee76c43cbe5384907f794d619db9b4d044eb54e223e0666e4da73f007e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e859ab68e89bde9988f3966d5b5352ccb56dc0d88ddd958d200b5f60e5f91653"
  end

  resource "man" do
    url "https://www.cs.duke.edu/~des/scripts/vip.man"
    sha256 "37b2753f7c7b39c81f97b10ea3f8e2dd5ea92ea8d130144fa99ed54306565f6f"
  end

  # use awk and /var/tmp as temporary directory
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/vip/19971113.patch"
    sha256 "96879c8d778f21b21aa27eb138424a82ffa8e8192b8cf15b2c4a5794908ef790"
  end

  def install
    bin.install "vip"
    resource("man").stage do
      man1.install "vip.man" => "vip.1"
    end
  end
end

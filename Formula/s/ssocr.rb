class Ssocr < Formula
  desc "Seven Segment Optical Character Recognition"
  homepage "https://www.unix-ag.uni-kl.de/~auerswal/ssocr/"
  url "https://www.unix-ag.uni-kl.de/~auerswal/ssocr/ssocr-2.25.0.tar.bz2"
  sha256 "75caf81b4ddce2ecbd5142db3bb1c26178889e37010074b8ec4fe0b5009c676a"
  license "GPL-3.0-or-later"
  head "https://github.com/auerswal/ssocr.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?ssocr[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fd18440ae84caaafcb2f5d788c6c23ae95c0240dfc9f6b5166f35eaca59d33b5"
    sha256 cellar: :any,                 arm64_sonoma:  "1ec94528ade23b5dae8efcd5d564d3bace361e8f2cb2187634f48f493954d9f0"
    sha256 cellar: :any,                 arm64_ventura: "7769d47981f3e86469509853748242c33416ea8ba2e95447f6480ba358f8e13e"
    sha256 cellar: :any,                 sonoma:        "c23687177f248921365de29f53ce885e3bdb2a62d72c1a3be95da8927f89d612"
    sha256 cellar: :any,                 ventura:       "6f3f9eb54854f922fbd2aa3403fa6a9af7741ecd3ae259aefe9fb341d7b0b6c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11ef4081db6d12e9ccc3683102223b2c4415712b0b54d1d66eb3083bcb3e2c4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72a782a7a689c2127b876983da317908aca53f0699f0eae1dd7f7d60985aeda0"
  end

  depends_on "pkgconf" => :build
  depends_on "imlib2"

  resource "homebrew-test-image" do
    url "https://www.unix-ag.uni-kl.de/~auerswal/ssocr/six_digits.png"
    sha256 "72b416cca7e98f97be56221e7d1a1129fc08d8ab15ec95884a5db6f00b2184f5"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    resource("homebrew-test-image").stage testpath
    assert_equal "431432", shell_output("#{bin}/ssocr -T #{testpath}/six_digits.png").chomp
  end
end

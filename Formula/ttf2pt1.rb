class Ttf2pt1 < Formula
  desc "True Type Font to Postscript Type 1 converter"
  homepage "https://ttf2pt1.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ttf2pt1/ttf2pt1/3.4.4/ttf2pt1-3.4.4.tgz"
  sha256 "ae926288be910073883b5c8a3b8fc168fde52b91199fdf13e92d72328945e1d0"

  livecheck do
    url :stable
    regex(%r{url=.*?/ttf2pt1[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "821e641a7addc5001641aac0fb7f610cc2ede29766dd09df88dea12968d3eda8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7b3f1cd65430d9bf494da6fceebb293a0f21840191009525090258871eced58b"
    sha256 cellar: :any_skip_relocation, monterey:       "94c056ea4644c7820eb48d3c85964b43c6e42f479efd374128f311f919a93f65"
    sha256 cellar: :any_skip_relocation, big_sur:        "736c22b9245fa658e10cbb775f943e93bbf42f90477999647461102e87832f29"
    sha256 cellar: :any_skip_relocation, catalina:       "29a39e797de6107bfe0878e68eb0eabd67d7cbb9b10e76055f1d9d3618a1a842"
    sha256 cellar: :any_skip_relocation, mojave:         "6cdd6394dba88c5c8acc8199443a3dcb8f3eaf357c8497d58b84c5a4e475cc5f"
    sha256 cellar: :any_skip_relocation, high_sierra:    "180c25530da15c48af99ea59e20f40e18e7339e812a375c9d3760ad23429a085"
    sha256 cellar: :any_skip_relocation, sierra:         "e70efa3a1b28b212ea2366ac50b33fbf48e9b7922d03f1a6b86965af87244bee"
    sha256 cellar: :any_skip_relocation, el_capitan:     "0ef606dfb439ad46c5442b35458f009e864ee3270145c7be940581a5d272bc54"
    sha256 cellar: :any_skip_relocation, yosemite:       "65c1456cab73a91161e4dddbc4f04842029a810a8e4e4c396e90fbf039e61f60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa39b65205b22d6c02893d9b5c503d0309edeb8884e0e9336c9d725dc049a666"
  end

  def install
    system "make", "all", "INSTDIR=#{prefix}"
    bin.install "ttf2pt1"
    man1.install "ttf2pt1.1"
  end
end

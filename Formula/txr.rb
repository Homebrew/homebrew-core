class Txr < Formula
  desc "Lisp-like programming language for convenient data munging"
  homepage "https://www.nongnu.org/txr/"
  url "http://www.kylheku.com/cgit/txr/snapshot/txr-284.tar.bz2"
  sha256 "76500e4e13b6b09b2991262647ddbb8aed77cb75d14a594819587bb9fbbc44e5"
  license "BSD-2-Clause"

  livecheck do
    url "http://www.kylheku.com/cgit/txr"
    regex(/href=.*?txr[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a26e3ff778e5e92e570ee2eb4fdecfe4c2ad7179ebaf4d3dd1e8d0c272be38de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4fec1149a5053be5c7917e8cf58f36528486ea2a317826516efe478a1f3da6f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ed980f78ca1e8f5f2a8dc4a315cbdf095c75b8e41b6e347d464169b8c7f4ed58"
    sha256 cellar: :any_skip_relocation, ventura:        "0fbe23e742120778f1a0807d1d0543d3b773d72b1d0a023663bdd6af7aa55262"
    sha256 cellar: :any_skip_relocation, monterey:       "cb11faf6bf35676deba19dc868d4ad39622f70254d9f84164d934b76778aded2"
    sha256 cellar: :any_skip_relocation, big_sur:        "29fa786bcd6955475b350f934be2977b72498da79e28b5cb89c60630101a651c"
  end

  depends_on "pkg-config" => :build
  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "libffi", since: :catalina

  def install
    system "./configure", "--prefix=#{prefix}", "--inline=static inline"
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "3", shell_output("#{bin}/txr -p '(+ 1 2)'").chomp
  end
end

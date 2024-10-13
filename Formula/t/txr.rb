class Txr < Formula
  desc "Lisp-like programming language for convenient data munging"
  homepage "https://www.nongnu.org/txr/"
  url "https://www.kylheku.com/cgit/txr/snapshot/txr-296.tar.bz2"
  sha256 "753e74c1f11c109a5235856b5e5800912b8267e08257a1a26f17e74efd5c2917"
  license "BSD-2-Clause"

  livecheck do
    url "https://www.kylheku.com/cgit/txr"
    regex(/href=.*?txr[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "72d459dc8256ecee224775d80decadcf71580c292f0450622ebf7b02364c9b00"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "665ae564cfe95691bf0c3d0be2efa808f6c84b9025d0cbebd5cc4d7900c09126"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4a0333a9d183f4b37c476abd38a40271e64cff8cf85131470d854c939ae7193e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c18f7d0d82dcf758371083137178c7c6bab011ee78d1655e5d7a830f77be6fba"
    sha256 cellar: :any_skip_relocation, sonoma:         "ff27d67de08045b34d41ee6089300571ca26bece1c891160b9a4501b1ffa66db"
    sha256 cellar: :any_skip_relocation, ventura:        "cd5d5b338ad9182a270b841a09e3314a26ff03187093ea3571b10748bdd6bb92"
    sha256 cellar: :any_skip_relocation, monterey:       "61091144d680585ceeaa4415d161e60e00a356c30d92795b2922fb1b49c3afb8"
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

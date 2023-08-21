class Txr < Formula
  desc "Lisp-like programming language for convenient data munging"
  homepage "https://www.nongnu.org/txr/"
  url "http://www.kylheku.com/cgit/txr/snapshot/txr-291.tar.bz2"
  sha256 "06d9373da9c96ba872a0cfa17d0abe12120c68bd9e77285fc71f7a2a9cbe69a0"
  license "BSD-2-Clause"

  livecheck do
    url "http://www.kylheku.com/cgit/txr"
    regex(/href=.*?txr[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2a90b1bc2569342674c6a54b64419d86f246c4adb70f5cf089af5c46c360e7a6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2403bf2f4673787c4319a3b7d85d27f7e235fdaa80fa591495905d8fef408ef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c25a52b18da9023faece62f10baa1e0eb9982b0a4e6aa8624bc0bd4081b7cb6f"
    sha256 cellar: :any_skip_relocation, ventura:        "33162896575e06dd8fa4ed56df95c2e4e509bdd55b35280e8b3615edc0614cd4"
    sha256 cellar: :any_skip_relocation, monterey:       "99594fe91c215bf5d504972056c5edc4d8a1287586565a02fd917181ff306655"
    sha256 cellar: :any_skip_relocation, big_sur:        "e32f277e872eef7356e7d60652be06b204818acbc783902578734390ba266500"
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

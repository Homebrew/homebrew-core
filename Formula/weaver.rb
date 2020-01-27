class Weaver < Formula
  desc "Command-line tool for Weaver"
  homepage "https://github.com/scribd/Weaver"
  url "https://github.com/scribd/Weaver/archive/1.0.2.tar.gz"
  sha256 "b19ba40b9f749701c9c9ad093a0ba87021b287e68f881177ff214379da8fbaf1"

  bottle do
    cellar :any_skip_relocation
    sha256 "cbb03dfe75009edbb3a8be316520676e6f9c859a587d6f32927db58c220504fa" => :catalina
    sha256 "f49049eb3f5be3b98b46ee025e242e1988c25fe2befec200a1f8c098e002ea65" => :mojave
  end

  depends_on :xcode => ["11.2", :build]

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    # Weaver uses Sourcekitten and thus, has the same sandbox issues.
    # Rewrite test after sandbox issues investigated.
    # https://github.com/Homebrew/homebrew/pull/50211
    system "#{bin}/weaver", "version"
  end
end

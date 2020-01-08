class Weaver < Formula
  desc "Command-line tool for Weaver"
  homepage "https://github.com/scribd/Weaver"
  url "https://github.com/scribd/Weaver/archive/1.0.1.tar.gz"
  sha256 "a73343ad8ad937bfc6f3af90534ad1e092a1ea5e234083a8b06138aea9cbd9c4"

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

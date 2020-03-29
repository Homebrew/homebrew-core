class Rbenv < Formula
  desc "Ruby version manager"
  homepage "https://github.com/rbenv/rbenv#readme"
  url "https://github.com/rbenv/rbenv/archive/v1.1.2.tar.gz"
  sha256 "80ad89ffe04c0b481503bd375f05c212bbc7d44ef5f5e649e0acdf25eba86736"
  head "https://github.com/rbenv/rbenv.git"

  bottle do
    cellar :any
    sha256 "503ed6d818502f00f031b9f49461934e252b9bfba2876e90a326fc27bb1052d6" => :catalina
    sha256 "d1019098dee8d037587069398e5ad04e6d736f834dc44ae73943bec46b10b260" => :mojave
    sha256 "b5984102794a9d39388ca1f6ec77965aeea29b971cc00cb5af8ede8ee6c926d6" => :high_sierra
    sha256 "873175a851e5aa4f5b3438072030b945c252f08a9a07760c64dc045e2cce4724" => :sierra
  end

  depends_on "ruby-build"

  uses_from_macos "ruby" => :test

  def install
    inreplace "libexec/rbenv" do |s|
      s.gsub! '"${BASH_SOURCE%/*}"/../libexec', libexec
      s.gsub! ":/usr/local/etc/rbenv.d", ":#{HOMEBREW_PREFIX}/etc/rbenv.d\\0" if HOMEBREW_PREFIX.to_s != "/usr/local"
    end

    # Compile optional bash extension.
    system "src/configure"
    system "make", "-C", "src"

    if build.head?
      # Record exact git revision for `rbenv --version` output
      git_revision = `git rev-parse --short HEAD`.chomp
      inreplace "libexec/rbenv---version", /^(version=)"([^"]+)"/,
                                           %Q(\\1"\\2-g#{git_revision}")
    end

    prefix.install ["bin", "completions", "libexec", "rbenv.d"]
  end

  test do
    shell_output("eval \"$(#{bin}/rbenv init -)\" && rbenv versions")
  end
end

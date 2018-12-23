class Rbenv < Formula
  desc "Ruby version manager"
  homepage "https://github.com/rbenv/rbenv#readme"
  url "https://github.com/rbenv/rbenv/archive/v1.1.1.tar.gz"
  sha256 "41f1a60714c55eceb21d692a469aee1ec4f46bba351d0dfcb0c660ff9cf1a1c9"
  head "https://github.com/rbenv/rbenv.git"

  bottle do
    rebuild 1
    sha256 "eef94cfa2b0dedc53e13f0f9f73946bcea8824dabcfdc06f86a62ea638ae65cc" => :mojave
    sha256 "dcde9bce89f83d313c5ad527bebda2fd931a88c18023d0ccccbf33f0d48f4c4d" => :high_sierra
    sha256 "5aa32d4c24d32be9d80deac4fe02fa672519374251c9fc2e3c4982c6d11b063a" => :sierra
    sha256 "687c347463aac118d1b8bc01892cfb7df54f03be3bf8cc2017abc93b16c878e8" => :el_capitan
  end

  depends_on "ruby-build"

  def install
    inreplace "libexec/rbenv" do |s|
      s.gsub! '"${BASH_SOURCE%/*}"/../libexec', libexec
      if HOMEBREW_PREFIX.to_s != "/usr/local"
        s.gsub! ":/usr/local/etc/rbenv.d", ":#{HOMEBREW_PREFIX}/etc/rbenv.d\\0"
      end
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

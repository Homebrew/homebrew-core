class Rbenv < Formula
  desc "Ruby version manager"
  homepage "https://github.com/rbenv/rbenv#readme"
  url "https://github.com/rbenv/rbenv/archive/v1.1.1.tar.gz"
  sha256 "41f1a60714c55eceb21d692a469aee1ec4f46bba351d0dfcb0c660ff9cf1a1c9"
  head "https://github.com/rbenv/rbenv.git"

  bottle do
    cellar :any
    rebuild 2
    sha256 "67f0becc3ef010f3b4f489d9ff852ff28988b18b968281c73a84892c7e26ec8f" => :mojave
    sha256 "faaede99c2b74417be708883586777c4b0747cdfc691aec10776682e31585083" => :high_sierra
    sha256 "39825fd08255d27551e9154d16691477cfecb3be52acf627d29986b4c8c0b87f" => :sierra
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

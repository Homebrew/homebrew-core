class Rbenv < Formula
  desc "Ruby version manager"
  homepage "https://github.com/rbenv/rbenv#readme"
  url "https://github.com/rbenv/rbenv/archive/v1.1.1.tar.gz"
  sha256 "41f1a60714c55eceb21d692a469aee1ec4f46bba351d0dfcb0c660ff9cf1a1c9"
  head "https://github.com/rbenv/rbenv.git"

  bottle do
    cellar :any
    sha256 "a99c9b4ba77938ce03b8e06e0e4d7670c611214b07b78d2b5e1bc9a7571f9186" => :sierra
    sha256 "9d1a7da30fb133b43b243e562167ffdde6c125f054c3fde7a866a0b15173f269" => :el_capitan
    sha256 "e3e0e0b32a1bb337178d915a91ac7f552153cbf351973f9ef1692d9644824f61" => :yosemite
  end

  depends_on "ruby-build" => :recommended

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

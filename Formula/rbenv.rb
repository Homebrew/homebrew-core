class Rbenv < Formula
  desc "Ruby version manager"
  homepage "https://github.com/rbenv/rbenv#readme"
  url "https://github.com/rbenv/rbenv/archive/v1.1.0.tar.gz"
  sha256 "070835ccb4a295a49712ded936be306433442129d5a8411dddf2f52e6732ce59"
  head "https://github.com/rbenv/rbenv.git"

  bottle do
    cellar :any
    sha256 "c9d34dee07b2a04d24aa1a8da30b0b5663529d69d7a46b29d979ceba79c81e67" => :sierra
    sha256 "2bdafe7927a69de0aedad237694431fddaa7cd2167855094a3c7caeeccc0a347" => :el_capitan
    sha256 "f829928b4796a022a60f10ab89c48f050ad8c69e40a74aa5fd3ba9b1b721769c" => :yosemite
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

  def caveats; <<-EOS.undent
    Rbenv stores data under ~/.rbenv by default. If you absolutely need to
    store everything under Homebrew's prefix, include this in your profile:
      export RBENV_ROOT=#{var}/rbenv

    To enable shims and autocompletion, run this and follow the instructions:
      rbenv init
    EOS
  end

  test do
    shell_output("eval \"$(#{bin}/rbenv init -)\" && rbenv versions")
  end
end

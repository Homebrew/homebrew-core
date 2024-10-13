class Rbenv < Formula
  desc "Ruby version manager"
  homepage "https://rbenv.org"
  url "https://github.com/rbenv/rbenv/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "7e49e529ce0c876748fa75a61efdd62efa2634906075431a1818b565825eb758"
  license "MIT"
  head "https://github.com/rbenv/rbenv.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "8c1ae8d76748e0140a458cd4c83b2f6ed83da17777940f7878ce5348ede8aeff"
  end

  depends_on "ruby-build"

  uses_from_macos "ruby" => :test

  def install
    # Build an `:all` bottle.
    inreplace "libexec/rbenv", "/usr/local", HOMEBREW_PREFIX

    if build.head?
      # Record exact git revision for `rbenv --version` output
      git_revision = Utils.git_short_head
      inreplace "libexec/rbenv---version", /^(version=)"([^"]+)"/,
                                           %Q(\\1"\\2-g#{git_revision}")
    end

    zsh_completion.install "completions/_rbenv" => "_rbenv"
    prefix.install ["bin", "completions", "libexec", "rbenv.d"]
    man1.install "share/man/man1/rbenv.1"
  end

  test do
    # Create a fake ruby version and executable.
    rbenv_root = Pathname(shell_output("#{bin}/rbenv root").strip)
    ruby_bin = rbenv_root/"versions/1.2.3/bin"
    foo_script = ruby_bin/"foo"
    foo_script.write "echo hello"
    chmod "+x", foo_script

    # Test versions. The second `rbenv` call is a shell function; do not add a `bin` prefix.
    versions = shell_output("eval \"$(#{bin}/rbenv init -)\" && rbenv versions").split("\n")
    assert_equal 2, versions.length
    assert_match(/\* system/, versions[0])
    assert_equal("  1.2.3", versions[1])

    # Test rehash.
    system bin/"rbenv", "rehash"
    refute_match "Cellar", (rbenv_root/"shims/foo").read
    # The second `rbenv` call is a shell function; do not add a `bin` prefix.
    assert_equal "hello", shell_output("eval \"$(#{bin}/rbenv init -)\" && rbenv shell 1.2.3 && foo").chomp
  end
end

class Rbenv < Formula
  desc "Ruby version manager"
  homepage "https://rbenv.org"
  url "https://github.com/rbenv/rbenv/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "e2104f6472d7a8477409c46d4de39562b4d01899148a3dbed73c1d99a0b4bb2a"
  license "MIT"
  head "https://github.com/rbenv/rbenv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8158fb1f059c1316523b2cc9074c5c041b3944828dc3b76cb032f893e754f013"
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

    # bash completion handled by rbenv-init
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

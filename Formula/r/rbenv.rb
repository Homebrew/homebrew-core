class Rbenv < Formula
  desc "Ruby version manager"
  homepage "https://rbenv.org"
  url "https://github.com/rbenv/rbenv/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "7e49e529ce0c876748fa75a61efdd62efa2634906075431a1818b565825eb758"
  license "MIT"
  head "https://github.com/rbenv/rbenv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6a9437cf6a6933473161ddcfcc9f9f8214ccbf8b1fcbf35e21662712dcfb80f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6a9437cf6a6933473161ddcfcc9f9f8214ccbf8b1fcbf35e21662712dcfb80f3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a9437cf6a6933473161ddcfcc9f9f8214ccbf8b1fcbf35e21662712dcfb80f3"
    sha256 cellar: :any_skip_relocation, sonoma:         "75461707772b43f2f3037a2176b820d9fe3039fb9255487f7d8d1f8e88a051f9"
    sha256 cellar: :any_skip_relocation, ventura:        "75461707772b43f2f3037a2176b820d9fe3039fb9255487f7d8d1f8e88a051f9"
    sha256 cellar: :any_skip_relocation, monterey:       "75461707772b43f2f3037a2176b820d9fe3039fb9255487f7d8d1f8e88a051f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "494c38f6026ed28e4fce71a2a75b2f4a612fa99711a5bd0d4dcc37c233bcbec4"
  end

  depends_on "ruby-build"

  uses_from_macos "ruby" => :test

  def install
    inreplace "libexec/rbenv" do |s|
      s.gsub! ":/usr/local/etc/rbenv.d", ":#{HOMEBREW_PREFIX}/etc/rbenv.d\\0" if HOMEBREW_PREFIX.to_s != "/usr/local"
    end

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

class Rbenv < Formula
  desc "Ruby version manager"
  homepage "https://github.com/rbenv/rbenv#readme"
  url "https://github.com/rbenv/rbenv/archive/v1.2.0.tar.gz"
  sha256 "3f3a31b8a73c174e3e877ccc1ea453d966b4d810a2aadcd4d8c460bc9ec85e0c"
  license "MIT"
  head "https://github.com/rbenv/rbenv.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8b4c091ff01a423d4c091cfde63243341517694014430d248c2b9fa6efeda8a7"
    sha256 cellar: :any,                 arm64_ventura:  "09bccc5974bd7b23f60a42c94bf7bc7d0e605cf4ef1f4068f63a1fe905bc5c74"
    sha256 cellar: :any,                 arm64_monterey: "dede9454bc8a665ac2b1858a0522fb77d95deebb5db7437918cfb056ff119b16"
    sha256 cellar: :any,                 arm64_big_sur:  "d5e6168ad6ab8843946273319fc6949b322c80f2d666a6bdda62466e256e6746"
    sha256 cellar: :any,                 sonoma:         "59a2e9120361bc20b5c3fe8122438e5e43ee00e475ea6730fe507fda2de6d7ab"
    sha256 cellar: :any,                 ventura:        "e654c2cf9b9966093b2d045cb9b12dbd32a7cd8926194838e13ee7d17184b1f5"
    sha256 cellar: :any,                 monterey:       "42657e04e2d1e8bf9abb9c5f0ba50e567df95f93a2a212491f005e4bd0ad9cee"
    sha256 cellar: :any,                 big_sur:        "8a1b159909d472cc461d0a9b85a192a31ab58860e34f022fcbb33175732d24aa"
    sha256 cellar: :any,                 catalina:       "a2ca52c4fe3b7000d9f84f81836ddcb9b3aea9c20ee092dd71c1e10cf3a6a19a"
    sha256 cellar: :any,                 mojave:         "87ca53a9f4f84aff56ccbf2f823f903d20bc6669dde548018892857cc8871936"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4be8e4efef32c1fcdaa585312b3262d33b3306d9d7d9c75abd1230227b10bb7"
  end

  depends_on "ruby-build"

  uses_from_macos "ruby" => :test

  def install
    inreplace "libexec/rbenv" do |s|
      # TODO: The following line can be removed in the next release.
      # rbenv/rbenv/pull/1428 (`brew audit` doesn't like URLs of merged PRs.)
      s.gsub! '"${BASH_SOURCE%/*}"/../libexec', libexec if build.stable?
      s.gsub! ":/usr/local/etc/rbenv.d", ":#{HOMEBREW_PREFIX}/etc/rbenv.d\\0" if HOMEBREW_PREFIX.to_s != "/usr/local"
    end

    if build.head?
      # Record exact git revision for `rbenv --version` output
      git_revision = Utils.git_short_head
      inreplace "libexec/rbenv---version", /^(version=)"([^"]+)"/,
                                           %Q(\\1"\\2-g#{git_revision}")

      # Install manpage
      man1.install "share/man/man1/rbenv.1"
    else
      # Compile optional bash extension.
      # TODO: This can probably be removed in the next release.
      # rbenv/rbenv/pull/1428 (`brew audit` doesn't like URLs of merged PRs.)
      system "src/configure"
      system "make", "-C", "src"
    end

    prefix.install ["bin", "completions", "libexec", "rbenv.d"]
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

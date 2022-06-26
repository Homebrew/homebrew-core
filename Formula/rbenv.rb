class Rbenv < Formula
  desc "Ruby version manager"
  homepage "https://github.com/rbenv/rbenv#readme"
  url "https://github.com/rbenv/rbenv/archive/v1.2.0.tar.gz"
  sha256 "3f3a31b8a73c174e3e877ccc1ea453d966b4d810a2aadcd4d8c460bc9ec85e0c"
  license "MIT"
  head "https://github.com/rbenv/rbenv.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "dede9454bc8a665ac2b1858a0522fb77d95deebb5db7437918cfb056ff119b16"
    sha256 cellar: :any,                 arm64_big_sur:  "d5e6168ad6ab8843946273319fc6949b322c80f2d666a6bdda62466e256e6746"
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
      s.gsub! '"${BASH_SOURCE%/*}"/../libexec', libexec
      s.gsub! ":/usr/local/etc/rbenv.d", ":#{HOMEBREW_PREFIX}/etc/rbenv.d\\0" if HOMEBREW_PREFIX.to_s != "/usr/local"
    end

    # Compile optional bash extension.
    system "src/configure"
    system "make", "-C", "src"

    if build.head?
      # Record exact git revision for `rbenv --version` output
      git_revision = Utils.git_short_head
      inreplace "libexec/rbenv---version", /^(version=)"([^"]+)"/,
                                           %Q(\\1"\\2-g#{git_revision}")
    end

    prefix.install ["bin", "completions", "libexec", "rbenv.d"]
  end

  test do
    # Create a fake ruby version and executable.
    rbenv_root = Pathname(shell_output("rbenv root").strip)
    ruby_bin = rbenv_root/"versions/1.2.3/bin"
    foo_script = ruby_bin/"foo"
    foo_script.write "echo hello"
    chmod "+x", foo_script

    # Test versions.
    versions = shell_output("eval \"$(#{bin}/rbenv init -)\" && rbenv versions").split("\n")
    assert_equal 2, versions.length
    assert_match(/\* system/, versions[0])
    assert_equal("  1.2.3", versions[1])

    # Test rehash.
    system "rbenv", "rehash"
    refute_match "Cellar", (rbenv_root/"shims/foo").read
    assert_equal "hello", shell_output("eval \"$(#{bin}/rbenv init -)\" && rbenv shell 1.2.3 && foo").chomp
  end
end

class Rbenv < Formula
  desc "Ruby version manager"
  homepage "https://github.com/rbenv/rbenv#readme"
  url "https://github.com/rbenv/rbenv/archive/v1.1.2.tar.gz"
  sha256 "80ad89ffe04c0b481503bd375f05c212bbc7d44ef5f5e649e0acdf25eba86736"
  license "MIT"
  head "https://github.com/rbenv/rbenv.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "19d0b9e3b11bcacdf692e78248c1b5764f7d3f4b58f2b83ad7b39562863ba82e"
    sha256 cellar: :any,                 big_sur:       "60b045c8843745c45d01616ee3f71b91f6a16ee09c47e23a7817a3edabeaccfd"
    sha256 cellar: :any,                 catalina:      "503ed6d818502f00f031b9f49461934e252b9bfba2876e90a326fc27bb1052d6"
    sha256 cellar: :any,                 mojave:        "d1019098dee8d037587069398e5ad04e6d736f834dc44ae73943bec46b10b260"
    sha256 cellar: :any,                 high_sierra:   "b5984102794a9d39388ca1f6ec77965aeea29b971cc00cb5af8ede8ee6c926d6"
    sha256 cellar: :any,                 sierra:        "873175a851e5aa4f5b3438072030b945c252f08a9a07760c64dc045e2cce4724"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47259687d198e3ec4ccceec09a1701a0804381ad73e8b01fb9756736ce8b78f6"
  end

  depends_on "ruby-build"

  uses_from_macos "ruby" => :test

  def install
    inreplace "libexec/rbenv" do |s|
      s.gsub! '"${BASH_SOURCE%/*}"/../libexec', libexec
      s.gsub! ":/usr/local/etc/rbenv.d", ":#{HOMEBREW_PREFIX}/etc/rbenv.d\\0" if HOMEBREW_PREFIX.to_s != "/usr/local"
    end

    inreplace "libexec/rbenv-rehash", "$(command -v rbenv)", opt_bin/"rbenv"

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

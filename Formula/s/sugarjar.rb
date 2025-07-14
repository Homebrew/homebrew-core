class Sugarjar < Formula
  desc "Helper utility for a better Git/GitHub experience"
  homepage "https://github.com/jaymzh/sugarjar/"
  url "https://github.com/jaymzh/sugarjar/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "7ae427d8dff1a293f063617365e76615ea7d238aaa7def260fd2b6f2cfa5e768"
  license "Apache-2.0"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd160e6f1f1274ca6ccd308d7a7b3561797957d2fdddaa97ed06d02b275b195d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd160e6f1f1274ca6ccd308d7a7b3561797957d2fdddaa97ed06d02b275b195d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dd160e6f1f1274ca6ccd308d7a7b3561797957d2fdddaa97ed06d02b275b195d"
    sha256 cellar: :any_skip_relocation, sonoma:        "1692b320ec4f62d0e176ac95bd437d706cb8e84720c5aa90a190cb36644e517f"
    sha256 cellar: :any_skip_relocation, ventura:       "1692b320ec4f62d0e176ac95bd437d706cb8e84720c5aa90a190cb36644e517f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9738a3c6fb7a4096ecd215c6557f9bcf2ce2c8216f51066d6ba1a5e4e8a15c1"
  end

  depends_on "gh"
  depends_on "ruby"

  uses_from_macos "libffi"

  def install
    ENV["BUNDLE_VERSION"] = "system" # Avoid installing Bundler into the keg
    ENV["GEM_HOME"] = libexec

    system "bundle", "config", "set", "without", "development", "test"
    system "bundle", "install"
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "#{name}-#{version}.gem"

    bin.install libexec/"bin/sj"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
    bash_completion.install "extras/sugarjar_completion.bash" => "sj"

    # Remove mkmf.log files to avoid shims references
    rm Dir["#{libexec}/extensions/*/*/*/mkmf.log"]
  end

  test do
    output = shell_output("#{bin}/sj lint", 1)
    assert_match "sugarjar must be run from inside a git repo", output
    output = shell_output("#{bin}/sj bclean", 1)
    assert_match "sugarjar must be run from inside a git repo", output
  end
end

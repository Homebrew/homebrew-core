class Sugarjar < Formula
  desc "Helper utility for a better Git/GitHub experience"
  homepage "https://github.com/jaymzh/sugarjar/"
  url "https://github.com/jaymzh/sugarjar/archive/refs/tags/v4.0.0.tar.gz"
  sha256 "1b698e12a0dc641046669ca87ca71c80fd96520c4cb6d350287a0d44df0df86d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "8427791235915a6c04a209ec93a570f060c34206dced895593bf2a384686a6fb"
    sha256 cellar: :any, arm64_sequoia: "0e27ea6b6d4afa239bc22eae321ad933fe0183287ed2c4a2a36ab9eb0d3d8936"
    sha256 cellar: :any, arm64_sonoma:  "b7ec9cb4ef766783f1d252867884818d4ee07054d6df31659f95b98b31a5d7b5"
    sha256 cellar: :any, sonoma:        "74eddea21cdd2e2ed6448ed71589d430cbf64739cebb8bb0a321401d5cf8c607"
    sha256 cellar: :any, arm64_linux:   "5df793971cdd9ea81a48541983ea24d73c1b6541fcfd971c6668b4d53d88b167"
    sha256 cellar: :any, x86_64_linux:  "974aeda705a2caa1d5c785763aa50fe3bebc2da2b0e6c2710f1ed31f37257f72"
  end

  depends_on "gh"
  depends_on "glab"
  depends_on "ruby"

  uses_from_macos "libffi"

  def install
    ENV["BUNDLE_FORCE_RUBY_PLATFORM"] = "1"
    ENV["BUNDLE_VERSION"] = "system" # Avoid installing Bundler into the keg
    ENV["BUNDLE_WITHOUT"] = "development test"
    ENV["GEM_HOME"] = libexec

    system "bundle", "install"
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "--ignore-dependencies", "#{name}-#{version}.gem"

    bin.install libexec/"bin/sj"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
    bash_completion.install "extras/sugarjar_completion.bash" => "sj"

    # Remove mkmf.log files to avoid shims references
    rm libexec.glob("extensions/*/*/*/mkmf.log")
  end

  test do
    output = shell_output("#{bin}/sj lint", 1)
    assert_match "sugarjar must be run from inside a git repo", output
    output = shell_output("#{bin}/sj bclean", 1)
    assert_match "sugarjar must be run from inside a git repo", output
  end
end

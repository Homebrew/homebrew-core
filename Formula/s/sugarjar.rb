class Sugarjar < Formula
  desc "Helper utility for a better Git/GitHub experience"
  homepage "https://github.com/jaymzh/sugarjar/"
  url "https://github.com/jaymzh/sugarjar/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "7ae427d8dff1a293f063617365e76615ea7d238aaa7def260fd2b6f2cfa5e768"
  license "Apache-2.0"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "485a7315667e784a8db3a41a9642116ed2dce02f972ca0527cc55795efcce237"
    sha256 cellar: :any,                 arm64_sequoia: "41881bd68b9c27052bd27ebaa906c3d172a1ec42cdf46bcf1b69286a3310f18e"
    sha256 cellar: :any,                 arm64_sonoma:  "d3da82b223693faff2895223140102ecf99654bba3e683abae401c2bf033fe2e"
    sha256 cellar: :any,                 sonoma:        "e1f2c10b2ecbe8c15464eba1f50d2aab0af50c538d37b2c351e728974786b35e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb0a1c68127928091f69bf22b6887312e77a6c27d28bb2f49bbb3529708f8920"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d7624e865ac1fe2600a77b31edb040f26b2604063d899b9700b32f786faca46"
  end

  depends_on "gh"
  depends_on "ruby"

  uses_from_macos "libffi"

  def install
    ENV["BUNDLE_FORCE_RUBY_PLATFORM"] = "1"
    ENV["BUNDLE_VERSION"] = "system" # Avoid installing Bundler into the keg
    ENV["BUNDLE_WITHOUT"] = "development test"
    ENV["GEM_HOME"] = libexec

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

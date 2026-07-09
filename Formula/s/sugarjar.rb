class Sugarjar < Formula
  desc "Helper utility for a better Git/GitHub experience"
  homepage "https://github.com/jaymzh/sugarjar/"
  url "https://github.com/jaymzh/sugarjar/archive/refs/tags/v3.0.1.tar.gz"
  sha256 "67c3a9475e6a37df5447a8346c51f5d62b9993b751280611dca8f05cd36403ad"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f8bffb7b3a57f0d7d21ea75d3c4b394fe30311292df9d84cc684fbd250393eb0"
    sha256 cellar: :any, arm64_sequoia: "43f8a2bcaa0d3663104070f9ce92874bc44b69e384a6dbbde13b1c0f0b815e5b"
    sha256 cellar: :any, arm64_sonoma:  "de1a25e1931a3eea78cd0de537e67e3a66180828cce6a9fff97abea1f39f6934"
    sha256 cellar: :any, sonoma:        "8250db93c1bfe795aad302b8e35be60ea33a31868a258d73217622425d376312"
    sha256 cellar: :any, arm64_linux:   "0bd49a2bcd1c49358460f8707f0ae388bba3305bc6fdcc6fa5f9657600b8499c"
    sha256 cellar: :any, x86_64_linux:  "01e78fffb1af9e45e2d75fb2de9d6cb06b6676a41b72398915c707358570b2d2"
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

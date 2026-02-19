class Sugarjar < Formula
  desc "Helper utility for a better Git/GitHub experience"
  homepage "https://github.com/jaymzh/sugarjar/"
  url "https://github.com/jaymzh/sugarjar/archive/refs/tags/v2.0.2.tar.gz"
  sha256 "b6db88d6539e662749a7cb78804bcdf89feac188310b87ab55d791aa18475ee3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1ea59ae258cb0a280477db2508df2f70645df8860d1713d34f1c3c7304e60d70"
    sha256 cellar: :any,                 arm64_sequoia: "701a642c86fa408018f6c4431c6b108667b177d46ea29db2bc31faf7568f02d8"
    sha256 cellar: :any,                 arm64_sonoma:  "2b66f25d655ae20cca9104a9b6ae6f3c19d7fe8bc82b3a86136e6c35e5693086"
    sha256 cellar: :any,                 sonoma:        "faa748b8acbc999bae3834785abfa3ee835bedd5c5ed1e11cd1a8d61b794e55b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a518760f0fae7fe19353cfa1ebcf304eb18dd15f60f362d28ebaef1cc2196256"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e3a13b8ac77471cf1ff034b5edb50ba9d77aba8856b45a82c57645647efdf78"
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

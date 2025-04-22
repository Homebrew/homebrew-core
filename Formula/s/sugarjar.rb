class Sugarjar < Formula
  desc "Helper utility for a better Git/GitHub experience"
  homepage "https://github.com/jaymzh/sugarjar/"
  url "https://github.com/jaymzh/sugarjar/archive/refs/tags/v1.1.3.tar.gz"
  sha256 "0ecdf0dcf44fb863b27a965cfe8d52b0436eb46f08503f2ab3a36d0bfea0b6e7"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "1302c342de73848865a19e3787af42f87ce47be169e9814c97674a54b95606e2"
    sha256 cellar: :any,                 arm64_sonoma:  "d395496268c76a8427c9ebd79f338286f14371acf4645bdf4d0f33e12f68327e"
    sha256 cellar: :any,                 arm64_ventura: "fec8c7de866860d40c1aa815823a97f65594a8cb013017eb582944e091ae1571"
    sha256 cellar: :any,                 sonoma:        "19e14dd394330e4563d3412ecf1c4c1182998cd89bcd55f607f13187b6b666a4"
    sha256 cellar: :any,                 ventura:       "07b6d776bc71f40f660938cc0b7c21bd83e8c3eb15a05afc20f7fb0fa181927b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce4aa243579bc576d949b309c7bd17cf15d09dd3ebde286fca60b68466fcfafd"
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

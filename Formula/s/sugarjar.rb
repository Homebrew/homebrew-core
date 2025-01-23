class Sugarjar < Formula
  desc "Helper utility for a better Git/GitHub experience"
  homepage "https://github.com/jaymzh/sugarjar/"
  url "https://github.com/jaymzh/sugarjar/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "5639b253c0e9d2c61e22d7b687c616750ab9359457241ec10844865228b3ce8d"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8d688e5faaf4e262f1fce1d6c89da0250a897c979956938668d6d9157de08c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8d688e5faaf4e262f1fce1d6c89da0250a897c979956938668d6d9157de08c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b8d688e5faaf4e262f1fce1d6c89da0250a897c979956938668d6d9157de08c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "03b52333c3f2564ea1c2fb278f00cc0493ad928006fd1e95c0e48db925520889"
    sha256 cellar: :any_skip_relocation, ventura:       "03b52333c3f2564ea1c2fb278f00cc0493ad928006fd1e95c0e48db925520889"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8d688e5faaf4e262f1fce1d6c89da0250a897c979956938668d6d9157de08c7"
  end

  depends_on "gh"
  # Requires Ruby >= 3.0
  depends_on "ruby"

  def install
    ENV["GEM_HOME"] = libexec
    system "bundle", "config", "set", "without", "development", "test"
    system "bundle", "install"
    system "gem", "build", "sugarjar.gemspec"
    system "gem", "install", "--ignore-dependencies", "sugarjar-#{version}.gem"
    bin.install libexec/"bin/sj"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
    bash_completion.install "extras/sugarjar_completion.bash" => "sj"
  end

  test do
    output = shell_output("#{bin}/sj lint", 1)
    assert_match "sugarjar must be run from inside a git repo", output
    output = shell_output("#{bin}/sj bclean", 1)
    assert_match "sugarjar must be run from inside a git repo", output
  end
end

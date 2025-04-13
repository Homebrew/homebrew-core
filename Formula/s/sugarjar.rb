class Sugarjar < Formula
  desc "Helper utility for a better Git/GitHub experience"
  homepage "https://github.com/jaymzh/sugarjar/"
  url "https://github.com/jaymzh/sugarjar/archive/refs/tags/v1.1.3.tar.gz"
  sha256 "0ecdf0dcf44fb863b27a965cfe8d52b0436eb46f08503f2ab3a36d0bfea0b6e7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "65ecd2cb3766d4be72ad9a424cda88fa979f8cddd12f3a2b30a60e4d8461faa4"
    sha256 cellar: :any,                 arm64_sonoma:  "e6eab020e7abe1cb0965d77b1f1c2a2d04e2d1db36554b2ac9519f0fea76d856"
    sha256 cellar: :any,                 arm64_ventura: "09fbeeaf8df6d59a5d76fe3e29bda8033dc7fef35c043ed4cf90cf59c9dc1d4b"
    sha256 cellar: :any,                 sonoma:        "30a3729d83daeed129153ca04149ec548755ba97b4bd09e733093a402bbc4e3a"
    sha256 cellar: :any,                 ventura:       "49e038185795406e1d605fa7ca8a42eb8d86c78300b368688cb0aee70ebc4abe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "623d49621a6203cee40d565a9aee6cc078add987fc50aa2dc9245ae411891414"
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

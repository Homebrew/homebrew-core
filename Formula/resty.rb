class Resty < Formula
  include Language::Python::Shebang

  desc "Command-line REST client that can be used in pipelines"
  homepage "https://github.com/micha/resty"
  url "https://github.com/micha/resty/archive/v3.0.tar.gz"
  sha256 "9ed8f50dcf70a765b3438840024b557470d7faae2f0c1957a011ebb6c94b9dd1"
  license "MIT"
  revision 1
  head "https://github.com/micha/resty.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7499f7b0641c562bae0884234014f9147cf382a4056f547345c2317922aae89a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ae63bd67ce12adff0eb514b088ee59aa9adbe8c8082921d756f7f126ec3b4259"
    sha256 cellar: :any_skip_relocation, monterey:       "028a0448e86f15286d17d3c26c2d2ac7e10ecb8db09b702fa72bdb3e6b90ab12"
    sha256 cellar: :any_skip_relocation, big_sur:        "c5d7a031c90f48e1cfd133b39cf38af25eec9c123d781071924ec30b71d89e87"
    sha256 cellar: :any_skip_relocation, catalina:       "104d7c808669976126d1906ea863b0f55d3b7612a0ecf5bf1314da0b53c8bdd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5eaed008e68ef6dd2be18998c2ad5e16f41d7930c8c72e19f336597666885ec7"
  end

  uses_from_macos "perl"

  on_linux do
    depends_on "python@3.10"
  end

  conflicts_with "nss", because: "both install `pp` binaries"

  resource "JSON" do
    url "https://cpan.metacpan.org/authors/id/I/IS/ISHIGAKI/JSON-2.94.tar.gz"
    sha256 "12271b5cee49943bbdde430eef58f1fe64ba6561980b22c69585e08fc977dc6d"
  end

  def install
    pkgshare.install "resty"

    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    resource("JSON").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make"
      system "make", "install"
    end

    bin.install "pp"
    bin.env_script_all_files(libexec/"bin", PERL5LIB: ENV["PERL5LIB"])

    bin.install "pypp"
    rewrite_shebang detected_python_shebang, bin/"pypp" if OS.linux?
  end

  def caveats
    <<~EOS
      To activate the resty, add the following at the end of your #{shell_profile}:
      source #{opt_pkgshare}/resty
    EOS
  end

  test do
    cmd = "bash -c '. #{pkgshare}/resty && resty https://api.github.com' 2>&1"
    assert_equal "https://api.github.com*", shell_output(cmd).chomp
    json_pretty_pypp=<<~EOS
      {
          "a": 1
      }
    EOS
    json_pretty_pp=<<~EOS
      {
         "a" : 1
      }
    EOS
    assert_equal json_pretty_pypp, pipe_output("#{bin}/pypp", '{"a":1}', 0)
    assert_equal json_pretty_pp, pipe_output("#{bin}/pp", '{"a":1}', 0).chomp
  end
end

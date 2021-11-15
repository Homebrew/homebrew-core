class Resty < Formula
  include Language::Python::Shebang

  desc "Command-line REST client that can be used in pipelines"
  homepage "https://github.com/micha/resty"
  url "https://github.com/micha/resty/archive/v3.0.tar.gz"
  sha256 "9ed8f50dcf70a765b3438840024b557470d7faae2f0c1957a011ebb6c94b9dd1"
  license "MIT"
  head "https://github.com/micha/resty.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ebf7e5221cc9828ea21047561a3c031c7ca812614789c729d6e3da9c5d84aab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "25695263de11d4434bf21750710883185d3630a38d201b7050105296cf503f90"
    sha256 cellar: :any_skip_relocation, monterey:       "02c552f9fa6eefb34fff30809401420f6da33ae2fe35eaa3de0b454b37c595a2"
    sha256 cellar: :any_skip_relocation, big_sur:        "03999dd31f795810e8febc7e5e206ff549d30f80062b6ea7a8235707b5b101f9"
    sha256 cellar: :any_skip_relocation, catalina:       "cb5ad84cbacf18282a5ad172a48471d0e7ac007e4799f358fff049b8309aa27f"
    sha256 cellar: :any_skip_relocation, mojave:         "beee774062f1c32a72f203d0c8c5b0900ce85589c32b385ade712b74e5e1c73b"
    sha256 cellar: :any_skip_relocation, high_sierra:    "e65c38b826157c35f2e3acd50846be691b6b1a6231a23c62567c24a052d0dc7e"
    sha256 cellar: :any_skip_relocation, sierra:         "fb754eb95b4cb573eef1807f5dcddab59e021a4326022a9fb8126fb8e80ff247"
    sha256 cellar: :any_skip_relocation, el_capitan:     "435854dd9bc54f09e46f3f895fc0801ce90a30b23b8d9f109f361f89666fcfe1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0407ee9d0d4ed110872714b36ba8abc7f95568edddd649b4969be978ca3d2826"
  end

  uses_from_macos "perl"

  on_linux do
    depends_on "python@3.9"
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

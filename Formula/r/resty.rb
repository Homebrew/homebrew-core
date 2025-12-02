class Resty < Formula
  include Language::Python::Shebang

  desc "Command-line REST client that can be used in pipelines"
  homepage "https://github.com/micha/resty"
  url "https://github.com/micha/resty/archive/refs/tags/v3.0.tar.gz"
  sha256 "9ed8f50dcf70a765b3438840024b557470d7faae2f0c1957a011ebb6c94b9dd1"
  license "MIT"
  revision 1
  head "https://github.com/micha/resty.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "822ecff7134608cd2f8b77f018ed5cdfe080ff2246ae16676b878d80e37dfee3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "ec5b20a27d1c9548291ebe45f91976563e04c018f9c1f8550fd616b715fa6791"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4eb2264c09b0b2578c1bfa8a834bc5d51093f49cb753e2dc192f2ca22a8b3d2a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1a3f52cd17e22f2d66c3577cc4f097624db50b8412a7c346568b120367284518"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a3f52cd17e22f2d66c3577cc4f097624db50b8412a7c346568b120367284518"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e5c7150a045b16d9a42e1a15882d3877aae7022500db56222b8ee065ac37a2b7"
    sha256 cellar: :any_skip_relocation, sonoma:         "bc5f8426043e865dfb78710f4df699da3eaadee702b1c0665a0c95630bdc318a"
    sha256 cellar: :any_skip_relocation, ventura:        "71ee80ce7ac984d228659e5411b95f8e28331b623421a78aa7e5cd70548189ad"
    sha256 cellar: :any_skip_relocation, monterey:       "71ee80ce7ac984d228659e5411b95f8e28331b623421a78aa7e5cd70548189ad"
    sha256 cellar: :any_skip_relocation, big_sur:        "0bd9a42083f75c4766e0f880fae27b5a62bdc54c5ce017793f731da663571449"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "6adf9e604e373a8dcb502b444e938daa08a8eee573a1e9b757eb3af4fb2848f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "664f2cbfde2529e7749b5f9b078cf1382fd0cf8f00a984b646d0b6c710a4a3b5"
  end

  uses_from_macos "perl"
  uses_from_macos "python"

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
    if !OS.mac? || MacOS.version >= :monterey
      rewrite_shebang detected_python_shebang(use_python_from_path: true), bin/"pypp"
    end
  end

  def caveats
    <<~EOS
      To activate the resty, add the following to your shell profile e.g. ~/.profile
      or ~/.zshrc:
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

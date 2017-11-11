class Resty < Formula
  desc "Command-line REST client that can be used in pipelines"
  homepage "https://github.com/micha/resty"
  url "https://github.com/micha/resty/archive/v3.0.tar.gz"
  sha256 "9ed8f50dcf70a765b3438840024b557470d7faae2f0c1957a011ebb6c94b9dd1"
  head "https://github.com/micha/resty.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "72d4399f3792dd43cfe2f8eb5ee18f3ba66b47a66433a965324e923efb722c68" => :high_sierra
    sha256 "382b3c9de2e9c2729c9eb808937ca42d7c9b0b3cd7cb60fdece40d652d64cb24" => :sierra
    sha256 "6bcc3e0e5c27ef7a59cdee22e495e5474458af91c7e481f938c3dbd48553d72c" => :el_capitan
  end

  resource "JSON" do
    url "https://cpan.metacpan.org/authors/id/I/IS/ISHIGAKI/JSON-2.94.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/I/IS/ISHIGAKI/JSON-2.94.tar.gz"
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
    bin.env_script_all_files(libexec/"bin", :PERL5LIB => ENV["PERL5LIB"])

    bin.install "pypp"
  end

  def caveats; <<~EOS
    To activate the resty, add the following at the end of your #{shell_profile}:
    source #{opt_pkgshare}/resty
    EOS
  end

  test do
    cmd = "zsh -c '. #{pkgshare}/resty && resty https://api.github.com' 2>&1"
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

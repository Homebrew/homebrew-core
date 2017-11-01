class Resty < Formula
  desc "Command-line REST client that can be used in pipelines"
  homepage "https://github.com/micha/resty"
  url "https://github.com/micha/resty/archive/2.3.tar.gz"
  sha256 "65c7bfe1268669d9da5456686c55f1976380b867db5bf12d3603972d7b2d65fd"
  head "https://github.com/micha/resty.git"

  # Don't take +x off these files. note: to be killed once a shebang is added to pp
  skip_clean "bin"

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
    chmod 0755, "#{bin}/pp" # note: to clean after a shebang is added to pp

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

class Resty < Formula
  include Language::Python::Shebang

  desc "Command-line REST client that can be used in pipelines"
  homepage "https://github.com/micha/resty"
  url "https://github.com/micha/resty/archive/refs/tags/v3.0.tar.gz"
  sha256 "9ed8f50dcf70a765b3438840024b557470d7faae2f0c1957a011ebb6c94b9dd1"
  license "MIT"
  revision 1
  head "https://github.com/micha/resty.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "142618e3523dfa8518328f4ba6d4bb685acfd7be85116996b7cb7ba4aa8f96a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "142618e3523dfa8518328f4ba6d4bb685acfd7be85116996b7cb7ba4aa8f96a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "142618e3523dfa8518328f4ba6d4bb685acfd7be85116996b7cb7ba4aa8f96a9"
    sha256 cellar: :any_skip_relocation, tahoe:         "a401e4be92df4f5e3ecbd104761ccbcdc35f77376ce428db247dbf8467493914"
    sha256 cellar: :any_skip_relocation, sequoia:       "a401e4be92df4f5e3ecbd104761ccbcdc35f77376ce428db247dbf8467493914"
    sha256 cellar: :any_skip_relocation, sonoma:        "a401e4be92df4f5e3ecbd104761ccbcdc35f77376ce428db247dbf8467493914"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c866b5ec9a984338dad43d3d225b39e11847f38723f90b5f1b3032d74f428bf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0b9d21b797d3a871dac057b6c67ad9d0c52c3d711741fb497f54989eb3f29cd"
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
    # `resty` uses `XDG_DATA_HOME` whenever `XDG_CONFIG_HOME` is set, but only creates the latter.
    ENV["XDG_DATA_HOME"] = testpath/"share"
    (testpath/"share/resty").mkpath

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

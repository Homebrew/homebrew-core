require "language/perl"

class Vnlog < Formula
  include Language::Perl::Shebang

  desc "Tools and libraries to read, write and process tabular text data"
  homepage "https://github.com/dkogan/vnlog"
  url "https://github.com/dkogan/vnlog/archive/refs/tags/v1.45.tar.gz"
  sha256 "ec9ab6f21b900beaae0e7e40892d587ac900d3cb36cf3ac1b175dbe9a2c10b7f"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  depends_on "mrbuild" => :build
  depends_on "mawk"
  depends_on "moreutils"
  depends_on "numpy"
  depends_on "python@3.15"

  uses_from_macos "perl"

  on_macos do
    # The GNUmakefile uses "define VAR =", which macOS's make 3.81 lacks
    depends_on "make" => :build
  end

  resource "Text::Aligner" do
    url "https://cpan.metacpan.org/authors/id/S/SH/SHLOMIF/Text-Aligner-0.16.tar.gz"
    sha256 "5c857dbce586f57fa3d7c4ebd320023ab3b2963b2049428ae01bd3bc4f215725"
  end

  resource "Text::Table" do
    url "https://cpan.metacpan.org/authors/id/S/SH/SHLOMIF/Text-Table-1.135.tar.gz"
    sha256 "fca3c16e83127f7c44dde3d3f7e3c73ea50d109a1054445de8082fea794ca5d2"
  end

  # Only for the test suite, which runs during the build
  resource "IPC::Run" do
    url "https://cpan.metacpan.org/authors/id/T/TO/TODDR/IPC-Run-20260402.0.tar.gz"
    sha256 "d6a326a8b1ffb19495dea4ff5a09ef138bf3562ab1b069d3fb7efbc77b9f6aca"
  end

  resource "Algorithm::Diff" do
    url "https://cpan.metacpan.org/authors/id/R/RJ/RJBS/Algorithm-Diff-1.201.tar.gz"
    sha256 "0022da5982645d9ef0207f3eb9ef63e70e9713ed2340ed7b3850779b0d842a7d"
  end

  resource "Text::Diff" do
    url "https://cpan.metacpan.org/authors/id/N/NE/NEILB/Text-Diff-1.46.tar.gz"
    sha256 "3fc983e3140fa2580250bbcf2b52e2acbdbc5abda4374c3be78235905d8ca8eb"
  end

  def python3
    "python3.15"
  end

  def install
    test_resources = ["IPC::Run", "Algorithm::Diff", "Text::Diff"]
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    ENV.prepend_create_path "PERL5LIB", buildpath/"testlib/lib/perl5"
    resources.each do |r|
      base = test_resources.include?(r.name) ? buildpath/"testlib" : libexec
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{base}", "NO_PERLLOCAL=1", "NO_PACKLIST=1"
        system "make", "install"
      end
    end

    # Each project's choose_mrbuild.mk uses ./mrbuild if it exists
    mrbuild = formula_opt_include("mrbuild")/"mrbuild"
    (buildpath/"mrbuild").install_symlink mrbuild.children
    (buildpath/"mrbuild").install_symlink formula_opt_bin("mrbuild") => "bin"

    # USE_DEBIAN_PATHS= skips mrbuild's Debian layout guesses.
    site_packages = Language::Python.site_packages(python3)
    args = %W[
      USE_DEBIAN_PATHS=
      DESTDIR=#{prefix}
      INSTALL_ROOT_LIB=/lib
      INSTALL_ROOT_BIN=/bin
      INSTALL_ROOT_INCLUDE=/include/vnlog
      INSTALL_ROOT_MAN=/share/man
      INSTALL_ROOT_PERL_MODULES=/lib/perl5
      INSTALL_ROOT_PY3_MODULES=/#{site_packages}
    ]

    make = OS.mac? ? "gmake" : "make"
    system make, *args
    # The Python parser test runs "python3" from the PATH
    with_env(PATH: "#{formula_opt_libexec("python@3.15")}/bin:#{ENV["PATH"]}") do
      system make, "check", *args
    end
    system make, "install", *args

    # The tools move to libexec/bin behind wrappers that set PERL5LIB. They
    # stay together there because vnl-join runs "$RealBin/vnl-sort" with perl.
    rewrite_shebang detected_perl_shebang, *bin.children
    bin.env_script_all_files libexec/"bin",
      PATH:     "#{formula_opt_bin("mawk")}:#{formula_opt_bin("moreutils")}:$PATH",
      PERL5LIB: "#{lib}/perl5:#{libexec}/lib/perl5"

    bash_completion.install Dir["completions/bash/*"]
    zsh_completion.install Dir["completions/zsh/_*"]
  end

  def caveats
    <<~EOS
      To use the Vnlog::Parser Perl module, add this to PERL5LIB:
        #{HOMEBREW_PREFIX}/lib/perl5
    EOS
  end

  test do
    (testpath/"data.vnl").write <<~EOS
      # a b
      1 10
      3 30
      2 20
    EOS

    assert_equal "# a b\n1 10\n2 20\n3 30\n", shell_output("#{bin}/vnl-sort -n -k a data.vnl")
    assert_equal "# s\n11\n33\n22\n", shell_output("#{bin}/vnl-filter -p s=a+b < data.vnl")
    assert_match(/^1 +10$/, shell_output("#{bin}/vnl-align < data.vnl"))

    system python3, "-c", <<~PY
      import vnlog
      data, names, _ = vnlog.slurp("data.vnl")
      assert names == ["a", "b"] and data[:, 0].sum() == 6
    PY

    (testpath/"fields.defs").write "double a\nint b\n"
    (testpath/"fields.h").write shell_output("#{bin}/vnl-gen-header < fields.defs")
    (testpath/"test.c").write <<~C
      #include "fields.h"
      int main(void)
      {
        vnlog_emit_legend();
        vnlog_set_field_value__a(1.5);
        vnlog_set_field_value__b(2);
        vnlog_emit_record();
        return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lvnlog", "-o", "test"
    assert_equal "# a b\n1.5 2\n", shell_output("./test")
  end
end

class Texlive < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "Free software distribution for the TeX typesetting system"
  homepage "https://www.tug.org/texlive/"
  url "https://github.com/TeX-Live/texlive-source/archive/refs/tags/svn58837.tar.gz"
  sha256 "0afa6919e44675b7afe0fa45344747afef07b6ee98eeb14ff6a2ef78f458fc12"
  license :public_domain
  revision 1
  head "https://github.com/TeX-Live/texlive-source.git", branch: "trunk"

  livecheck do
    url :stable
    regex(%r{href=["']?[^"' >]*?/tag/\D+(\d+(?:\.\d+)*)["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 arm64_big_sur: "f0038b8dcf103be8c0a244fe468b19453b7d87d114a407d4491d68cb0a43fd40"
    sha256 big_sur:       "499d3a4288ce44171bd03c8302cfed3c82a9c8068b9bc906a561f1ceef09de6c"
    sha256 catalina:      "ff3e7293bdf2febf0320060541a9320ca31ec61dd434eeb2f537a84e4cda0f5b"
    sha256 mojave:        "7c27168b1a8592bc78b82ec0d92a87595bce2a77f7b96d9eb69af49af5c4d9e6"
    sha256 x86_64_linux:  "9100a01d16c8e182e31c78d531ca806419e70beab6c08e10d80e778231b12743"
  end

  depends_on "cairo"
  depends_on "clisp"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "gd"
  depends_on "ghostscript"
  depends_on "gmp"
  depends_on "graphite2"
  depends_on "harfbuzz"
  depends_on "libpng"
  depends_on "libxft"
  depends_on "lua"
  depends_on "luajit-openresty"
  depends_on "mpfr"
  depends_on "openjdk"
  depends_on "openssl@1.1"
  depends_on "perl"
  depends_on "pixman"
  depends_on "potrace"
  depends_on "pstoedit"
  depends_on "python@3.9"

  uses_from_macos "icu4c"
  uses_from_macos "ncurses"
  uses_from_macos "ruby"
  uses_from_macos "tcl-tk"
  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "gcc"
    depends_on "libice"
    depends_on "libsm"
    depends_on "libx11"
    depends_on "libxaw"
    depends_on "libxext"
    depends_on "libxmu"
    depends_on "libxpm"
    depends_on "libxt"
    depends_on "mesa"
  end

  conflicts_with "cweb", because: "both install `cweb` binaries"
  conflicts_with "lcdf-typetools", because: "both install a `cfftot1` executable"

  fails_with gcc: "5"

  resource "texlive-extra" do
    url "https://ftp.math.utah.edu/pub/tex/historic/systems/texlive/2021/texlive-20210325-extra.tar.xz"
    sha256 "46a3f385d0b30893eec6b39352135d2929ee19a0a81df2441bfcaa9f6c78339c"
  end

  resource "install-tl" do
    url "https://ftp.math.utah.edu/pub/tex/historic/systems/texlive/2021/install-tl-unx.tar.gz"
    sha256 "74eac0855e1e40c8db4f28b24ef354bd7263c1f76031bdc02b52156b572b7a1d"
  end

  resource "texlive-texmf" do
    url "https://ftp.math.utah.edu/pub/tex/historic/systems/texlive/2021/texlive-20210325-texmf.tar.xz"
    sha256 "ff12d436c23e99fb30aad55924266104356847eb0238c193e839c150d9670f1c"
  end

  resource "Module::Build" do
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/Module-Build-0.4231.tar.gz"
    sha256 "7e0f4c692c1740c1ac84ea14d7ea3d8bc798b2fb26c09877229e04f430b2b717"
  end

  resource "ExtUtils::Config" do
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/ExtUtils-Config-0.008.tar.gz"
    sha256 "ae5104f634650dce8a79b7ed13fb59d67a39c213a6776cfdaa3ee749e62f1a8c"
  end

  resource "ExtUtils::Helpers" do
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/ExtUtils-Helpers-0.026.tar.gz"
    sha256 "de901b6790a4557cf4ec908149e035783b125bf115eb9640feb1bc1c24c33416"
  end

  resource "ExtUtils::InstallPaths" do
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/ExtUtils-InstallPaths-0.012.tar.gz"
    sha256 "84735e3037bab1fdffa3c2508567ad412a785c91599db3c12593a50a1dd434ed"
  end

  resource "Module::Build::Tiny" do
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/Module-Build-Tiny-0.039.tar.gz"
    sha256 "7d580ff6ace0cbe555bf36b86dc8ea232581530cbeaaea09bccb57b55797f11c"
  end

  resource "Digest::SHA1" do
    url "https://cpan.metacpan.org/authors/id/G/GA/GAAS/Digest-SHA1-2.13.tar.gz"
    sha256 "68c1dac2187421f0eb7abf71452a06f190181b8fc4b28ededf5b90296fb943cc"
  end

  resource "Try::Tiny" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/Try-Tiny-0.31.tar.gz"
    sha256 "3300d31d8a4075b26d8f46ce864a1d913e0e8467ceeba6655d5d2b2e206c11be"
  end

  resource "Path::Tiny" do
    url "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/Path-Tiny-0.122.tar.gz"
    sha256 "4bc6f76d0548ccd8b38cb66291a885bf0de453d0167562c7b82e8861afdcfb7c"
  end

  resource "File::Copy::Recursive" do
    url "https://cpan.metacpan.org/authors/id/D/DM/DMUEY/File-Copy-Recursive-0.45.tar.gz"
    sha256 "d3971cf78a8345e38042b208bb7b39cb695080386af629f4a04ffd6549df1157"
  end

  resource "File::Which" do
    url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/File-Which-1.27.tar.gz"
    sha256 "3201f1a60e3f16484082e6045c896842261fc345de9fb2e620fd2a2c7af3a93a"
  end

  resource "IPC::System::Simple" do
    url "https://cpan.metacpan.org/authors/id/J/JK/JKEENAN/IPC-System-Simple-1.30.tar.gz"
    sha256 "22e6f5222b505ee513058fdca35ab7a1eab80539b98e5ca4a923a70a8ae9ba9e"
  end

  resource "URI" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/URI-5.10.tar.gz"
    sha256 "16325d5e308c7b7ab623d1bf944e1354c5f2245afcfadb8eed1e2cae9a0bd0b5"
  end

  resource "TimeDate" do
    url "https://cpan.metacpan.org/authors/id/A/AT/ATOOMIC/TimeDate-2.33.tar.gz"
    sha256 "c0b69c4b039de6f501b0d9f13ec58c86b040c1f7e9b27ef249651c143d605eb2"
  end

  resource "Crypt::RC4" do
    url "https://cpan.metacpan.org/authors/id/S/SI/SIFUKURT/Crypt-RC4-2.02.tar.gz"
    sha256 "5ec4425c6bc22207889630be7350d99686e62a44c6136960110203cd594ae0ea"
  end

  resource "Digest::Perl::MD5" do
    url "https://cpan.metacpan.org/authors/id/D/DE/DELTA/Digest-Perl-MD5-1.9.tar.gz"
    sha256 "7100cba1710f45fb0e907d8b1a7bd8caef35c64acd31d7f225aff5affeecd9b1"
  end

  resource "IO::Scalar" do
    url "https://cpan.metacpan.org/authors/id/C/CA/CAPOEIRAB/IO-Stringy-2.113.tar.gz"
    sha256 "51220fcaf9f66a639b69d251d7b0757bf4202f4f9debd45bdd341a6aca62fe4e"
  end

  resource "OLE::Storage_Lite" do
    url "https://cpan.metacpan.org/authors/id/J/JM/JMCNAMARA/OLE-Storage_Lite-0.20.tar.gz"
    sha256 "ab18a6171c0e08ea934eea14a0ab4f3a8909975dda9da42124922eb41e84f8ba"
  end

  resource "Spreadsheet::ParseExcel" do
    url "https://cpan.metacpan.org/authors/id/D/DO/DOUGW/Spreadsheet-ParseExcel-0.65.tar.gz"
    sha256 "6ec4cb429bd58d81640fe12116f435c46f51ff1040c68f09cc8b7681c1675bec"
  end

  resource "Encode::Locale" do
    url "https://cpan.metacpan.org/authors/id/G/GA/GAAS/Encode-Locale-1.05.tar.gz"
    sha256 "176fa02771f542a4efb1dbc2a4c928e8f4391bf4078473bd6040d8f11adb0ec1"
  end

  resource "HTTP::Date" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Date-6.05.tar.gz"
    sha256 "365d6294dfbd37ebc51def8b65b81eb79b3934ecbc95a2ec2d4d827efe6a922b"
  end

  resource "LWP::MediaTypes" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/LWP-MediaTypes-6.04.tar.gz"
    sha256 "8f1bca12dab16a1c2a7c03a49c5e58cce41a6fec9519f0aadfba8dad997919d9"
  end

  resource "IO::HTML" do
    url "https://cpan.metacpan.org/authors/id/C/CJ/CJM/IO-HTML-1.004.tar.gz"
    sha256 "c87b2df59463bbf2c39596773dfb5c03bde0f7e1051af339f963f58c1cbd8bf5"
  end

  resource "HTTP::Request::Common" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Message-6.36.tar.gz"
    sha256 "576a53b486af87db56261a36099776370c06f0087d179fc8c7bb803b48cddd76"
  end

  resource "HTML::Tagset" do
    url "https://cpan.metacpan.org/authors/id/P/PE/PETDANCE/HTML-Tagset-3.20.tar.gz"
    sha256 "adb17dac9e36cd011f5243881c9739417fd102fce760f8de4e9be4c7131108e2"
  end

  resource "HTML::Parser" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTML-Parser-3.76.tar.gz"
    sha256 "64d9e2eb2b420f1492da01ec0e6976363245b4be9290f03f10b7d2cb63fa2f61"
  end

  resource "HTML::TreeBuilder" do
    url "https://cpan.metacpan.org/authors/id/K/KE/KENTNL/HTML-Tree-5.07.tar.gz"
    sha256 "f0374db84731c204b86c1d5b90975fef0d30a86bd9def919343e554e31a9dbbf"
  end

  resource "File::Slurper" do
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/File-Slurper-0.013.tar.gz"
    sha256 "e2f6a4029a6a242d50054044f1fb86770b9b5cc4daeb1a967f91ffb42716a8c5"
  end

  resource "Font::AFM" do
    url "https://cpan.metacpan.org/authors/id/G/GA/GAAS/Font-AFM-1.20.tar.gz"
    sha256 "32671166da32596a0f6baacd0c1233825a60acaf25805d79c81a3f18d6088bc1"
  end

  resource "HTML::FormatText" do
    url "https://cpan.metacpan.org/authors/id/N/NI/NIGELM/HTML-Formatter-2.16.tar.gz"
    sha256 "cb0a0dd8aa5e8ba9ca214ce451bf4df33aa09c13e907e8d3082ddafeb30151cc"
  end

  resource "File::Listing" do
    url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/File-Listing-6.14.tar.gz"
    sha256 "15b3a4871e23164a36f226381b74d450af41f12cc94985f592a669fcac7b48ff"
  end

  resource "HTTP::Cookies" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Cookies-6.10.tar.gz"
    sha256 "e36f36633c5ce6b5e4b876ffcf74787cc5efe0736dd7f487bdd73c14f0bd7007"
  end

  resource "HTTP::Daemon" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Daemon-6.13.tar.gz"
    sha256 "d184d1f3e51e690d60e4b00195aa69f679169c858f2aab419997c70892014516"
  end

  resource "HTTP::Negotiate" do
    url "https://cpan.metacpan.org/authors/id/G/GA/GAAS/HTTP-Negotiate-6.01.tar.gz"
    sha256 "1c729c1ea63100e878405cda7d66f9adfd3ed4f1d6cacaca0ee9152df728e016"
  end

  resource "Net::HTTP" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/Net-HTTP-6.22.tar.gz"
    sha256 "62faf9a5b84235443fe18f780e69cecf057dea3de271d7d8a0ba72724458a1a2"
  end

  resource "WWW::RobotRules" do
    url "https://cpan.metacpan.org/authors/id/G/GA/GAAS/WWW-RobotRules-6.02.tar.gz"
    sha256 "46b502e7a288d559429891eeb5d979461dd3ecc6a5c491ead85d165b6e03a51e"
  end

  resource "LWP" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/libwww-perl-6.61.tar.gz"
    sha256 "2f69069bd0df0ee222e25d41093bcc42e58d0a45885fba400356454c25621a5f"
  end

  resource "CGI" do
    url "https://cpan.metacpan.org/authors/id/L/LE/LEEJO/CGI-4.54.tar.gz"
    sha256 "9608a044ae2e87cefae8e69b113e3828552ddaba0d596a02f9954c6ac17fa294"
  end

  resource "HTML::Form" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTML-Form-6.07.tar.gz"
    sha256 "7daa8c7eaff4005501c3431c8bf478d58bbee7b836f863581aa14afe1b4b6227"
  end

  resource "HTTP::Server::Simple" do
    url "https://cpan.metacpan.org/authors/id/B/BP/BPS/HTTP-Server-Simple-0.52.tar.gz"
    sha256 "d8939fa4f12bd6b8c043537fd0bf96b055ac3686b9cdd9fa773dca6ae679cb4c"
  end

  resource "WWW::Mechanize" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/WWW-Mechanize-2.06.tar.gz"
    sha256 "d97cd31e35fd1ff7078d3f568b62e3fe3911843a64d3c2d078eebd3ff9b8b38d"
  end

  resource "Mozilla::CA" do
    url "https://cpan.metacpan.org/authors/id/A/AB/ABH/Mozilla-CA-20211001.tar.gz"
    sha256 "122c8900000a9d388aa8e44f911cab6c118fe8497417917a84a8ec183971b449"
  end

  resource "Net::SSLeay" do
    url "https://cpan.metacpan.org/authors/id/C/CH/CHRISN/Net-SSLeay-1.92.tar.gz"
    sha256 "47c2f2b300f2e7162d71d699f633dd6a35b0625a00cbda8c50ac01144a9396a9"
  end

  resource "IO::Socket::SSL" do
    url "https://cpan.metacpan.org/authors/id/S/SU/SULLR/IO-Socket-SSL-2.074.tar.gz"
    sha256 "36486b6be49da4d029819cf7069a7b41ed48af0c87e23be0f8e6aba23d08a832"
  end

  resource "LWP::Protocol::https" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/LWP-Protocol-https-6.10.tar.gz"
    sha256 "cecfc31fe2d4fc854cac47fce13d3a502e8fdfe60c5bc1c09535743185f2a86c"
  end

  resource "Tk" do
    url "https://cpan.metacpan.org/authors/id/S/SR/SREZIC/Tk-804.036.tar.gz"
    sha256 "32aa7271a6bdfedc3330119b3825daddd0aa4b5c936f84ad74eabb932a200a5e"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/94/9c/cb656d06950268155f46d4f6ce25d7ffc51a0da47eadf1b164bbf23b718b/Pygments-2.11.2.tar.gz"
    sha256 "4e426f72023d88d03b2fa258de560726ce890ff3b630f88c21cbb8b2503b8c6a"
  end

  def install
    # Install Perl resources
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    ENV["PERL_MM_USE_DEFAULT"] = "1"
    ENV["OPENSSL_PREFIX"] = Formula["openssl@1.1"].opt_prefix

    tex_resources = %w[texlive-extra install-tl texlive-texmf]
    python_resources = %w[Pygments]

    resources.each do |r|
      r.stage do
        next if tex_resources.include? r.name

        next if python_resources.include? r.name

        if File.exist? "Makefile.PL"
          system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}",
            "CCFLAGS=-I#{Formula["freetype"].opt_include}/freetype2"
          system "make"
          system "make", "install"
        else
          system "perl", "Build.PL", "--install_base", libexec
          system "./Build"
          system "./Build", "install"
        end
      end
    end

    # Install Python resources
    venv = virtualenv_create(libexec, "python3")
    venv.pip_install resource("Pygments")

    # Install TeXLive resources
    resource("texlive-extra").stage do
      share.install "tlpkg"
    end

    resource("install-tl").stage do
      cd "tlpkg" do
        (share/"tlpkg").install "installer"
        (share/"tlpkg").install "tltcl"
      end
    end

    resource("texlive-texmf").stage do
      share.install "texmf-dist"
    end

    # Clean unused files
    rm_rf share/"texmf-dist/doc"
    rm_rf share/"tlpkg/installer/wget"
    rm_rf share/"tlpkg/installer/xz"

    # Set up config files to use the correct path for the TeXLive root
    inreplace buildpath/"texk/kpathsea/texmf.cnf",
      "TEXMFROOT = $SELFAUTOPARENT", "TEXMFROOT = $SELFAUTODIR/share"
    inreplace share/"texmf-dist/web2c/texmfcnf.lua",
      "selfautoparent:texmf", "selfautodir:share/texmf"

    # Fix path resolution in some scripts.  The fix for tlmgr.pl, TLUTils.pm, and
    # tlshell is being upstreamed here: https://www.tug.org/pipermail/tex-live/2021-September/047394.html.
    # The fix for cjk-gs-integrate.pl is being upstreamed here: https://github.com/texjporg/cjk-gs-support/pull/50.
    # The author of crossrefware and pedigree-perl has been contacted by email.
    pathfix_files = %W[
      #{buildpath}/texk/texlive/linked_scripts/cjk-gs-integrate/cjk-gs-integrate.pl
      #{buildpath}/texk/texlive/linked_scripts/crossrefware/bbl2bib.pl
      #{buildpath}/texk/texlive/linked_scripts/crossrefware/bibdoiadd.pl
      #{buildpath}/texk/texlive/linked_scripts/crossrefware/bibmradd.pl
      #{buildpath}/texk/texlive/linked_scripts/crossrefware/biburl2doi.pl
      #{buildpath}/texk/texlive/linked_scripts/crossrefware/bibzbladd.pl
      #{buildpath}/texk/texlive/linked_scripts/crossrefware/ltx2crossrefxml.pl
      #{buildpath}/texk/texlive/linked_scripts/texlive/tlmgr.pl
      #{buildpath}/texk/texlive/linked_scripts/pedigree-perl/pedigree.pl
      #{buildpath}/texk/texlive/linked_scripts/tlshell/tlshell.tcl
      #{share}/tlpkg/TeXLive/TLUtils.pm
    ]

    inreplace pathfix_files, "SELFAUTOPARENT", "TEXMFROOT"

    args = std_configure_args + [
      "--disable-dvisvgm", # needs its own formula
      "--disable-missing",
      "--disable-native-texlive-build", # needed when doing a distro build
      "--disable-static",
      "--disable-ps2eps", # provided by ps2eps formula
      "--disable-psutils", # provided by psutils formula
      "--disable-t1utils", # provided by t1utils formula
      "--enable-build-in-source-tree",
      "--enable-shared",
      "--enable-compiler-warnings=yes",
      "--with-banner-add=/#{tap.user}",
      "--with-system-clisp-runtime=system",
      "--with-system-cairo",
      "--with-system-freetype2",
      "--with-system-gd",
      "--with-system-gmp",
      "--with-system-graphite2",
      "--with-system-harfbuzz",
      "--with-system-icu",
      "--with-system-libpng",
      "--with-system-mpfr",
      "--with-system-ncurses",
      "--with-system-pixman",
      "--with-system-potrace",
      "--with-system-zlib",
    ]

    args << if OS.mac?
      "--without-x"
    else
      # Make sure xdvi uses xaw, even if motif is available
      "--with-xdvi-x-toolkit=xaw"
    end

    system "./configure", *args
    system "make"
    system "make", "install"
    system "make", "texlinks"

    # Create tlmgr config file.  This file limits the actions that the user
    # can perform in 'system' mode, which would write to the cellar.  'tlmgr' should
    # be used with --usermode whenever possible.
    (share/"texmf-config/tlmgr/config").write <<~EOS
      allowed-actions=candidates,check,dump-tlpdb,help,info,list,print-platform,print-platform-info,search,show,version,init-usertree
    EOS

    # Delete some Perl scripts that are provided by existing formulae as newer versions.
    rm bin/"latexindent" # provided by latexindent formula
    rm bin/"latexdiff" # provided by latexdiff formula
    rm bin/"latexdiff-vc" # provided by latexdiff formula
    rm bin/"latexrevise" # provided by latexdiff formula

    # Wrap some Perl scripts in an env script so that they can find dependencies
    env_script_files = %w[
      crossrefware/bbl2bib.pl
      crossrefware/bibdoiadd.pl
      crossrefware/bibmradd.pl
      crossrefware/biburl2doi.pl
      crossrefware/bibzbladd.pl
      crossrefware/ltx2crossrefxml.pl
      ctan-o-mat/ctan-o-mat.pl
      ctanify/ctanify
      ctanupload/ctanupload.pl
      exceltex/exceltex
      latex-git-log/latex-git-log
      pax/pdfannotextractor.pl
      ptex-fontmaps/kanji-fontmap-creator.pl
      purifyeps/purifyeps
      svn-multi/svn-multi.pl
      texdoctk/texdoctk.pl
      ulqda/ulqda.pl
    ]

    env_script_files.each do |perl_script|
      bin_name = File.basename(perl_script, ".pl")
      rm bin/bin_name
      (bin/bin_name).write_env_script(share/"texmf-dist/scripts"/perl_script, PERL5LIB: ENV["PERL5LIB"])
    end

    # Wrap some Python scripts so they can find dependencies and fix depythontex.
    python_path = libexec/Language::Python.site_packages("python3")
    ENV.prepend_path "PYTHONPATH", python_path
    rm bin/"pygmentex"
    rm bin/"pythontex"
    rm bin/"depythontex"
    (bin/"pygmentex").write_env_script(share/"texmf-dist/scripts/pygmentex/pygmentex.py",
      PYTHONPATH: ENV["PYTHONPATH"])
    (bin/"pythontex").write_env_script(share/"texmf-dist/scripts/pythontex/pythontex3.py",
      PYTHONPATH: ENV["PYTHONPATH"])
    ln_sf share/"texmf-dist/scripts/pythontex/depythontex3.py", bin/"depythontex"

    # Rewrite shebangs in some Python scripts so they use brewed Python.
    python_shebang_rewrites = %w[
      dviasm/dviasm.py
      latex-make/figdepth.py
      latex-make/gensubfig.py
      latex-make/latexfilter.py
      latex-make/svg2dev.py
      latex-make/svgdepth.py
      latex-papersize/latex-papersize.py
      lilyglyphs/lilyglyphs_common.py
      lilyglyphs/lily-glyph-commands.py
      lilyglyphs/lily-image-commands.py
      lilyglyphs/lily-rebuild-pdfs.py
      pdfbook2/pdfbook2
      pygmentex/pygmentex.py
      pythontex/depythontex3.py
      pythontex/pythontex3.py
      pythontex/pythontex_install.py
      spix/spix.py
      texliveonfly/texliveonfly.py
      webquiz/webquiz
      webquiz/webquiz.py
      webquiz/webquiz_makequiz.py
      webquiz/webquiz_util.py
    ]

    python_shebang_rewrites.each do |python_script|
      rewrite_shebang detected_python_shebang, share/"texmf-dist/scripts"/python_script
    end

    # Delete ebong because it requires Python 2
    rm bin/"ebong"

    # Initialize texlive environment
    ENV.prepend_path "PATH", bin
    system "fmtutil-sys", "--all"
    system "mtxrun", "--generate"
    system "mktexlsr"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/tex --help")
    assert_match "revision", shell_output("#{bin}/tlmgr --version")
    assert_match "AMS mathematical facilities for LaTeX", shell_output("#{bin}/tlmgr info amsmath")

    (testpath/"test.latex").write <<~EOS
      \\documentclass[12pt]{article}
      \\usepackage[utf8]{inputenc}
      \\usepackage{amsmath}
      \\usepackage{lipsum}

      \\title{\\LaTeX\\ test}
      \\author{\\TeX\\ Team}
      \\date{September 2021}

      \\begin{document}

      \\maketitle

      \\section*{An equation with amsmath}
      \\begin{equation} \\label{eu_eqn}
      e^{\\pi i} + 1 = 0
      \\end{equation}
      The beautiful equation \\ref{eu_eqn} is known as the Euler equation.

      \\section*{Lorem Ipsum}
      \\lipsum[3]

      \\lipsum[5]

      \\end{document}
    EOS

    assert_match "Output written on test.dvi", shell_output("#{bin}/latex #{testpath}/test.latex")
    assert_predicate testpath/"test.dvi", :exist?
    assert_match "Output written on test.pdf", shell_output("#{bin}/pdflatex #{testpath}/test.latex")
    assert_predicate testpath/"test.pdf", :exist?
    assert_match "This is dvips", shell_output("#{bin}/dvips #{testpath}/test.dvi 2>&1")
    assert_predicate testpath/"test.ps", :exist?
  end
end

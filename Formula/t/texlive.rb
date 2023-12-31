class Texlive < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "Free software distribution for the TeX typesetting system"
  homepage "https://www.tug.org/texlive/"
  url "https://ftp.math.utah.edu/pub/tex/historic/systems/texlive/2023/texlive-20230313-source.tar.xz"
  mirror "https://ftp.tu-chemnitz.de/pub/tug/historic/systems/texlive/2023/texlive-20230313-source.tar.xz"
  sha256 "3878aa0e1ed0301c053b0e2ee4e9ad999c441345f4882e79bdd1c8f4ce9e79b9"
  license :cannot_represent
  revision 2
  head "https://github.com/TeX-Live/texlive-source.git", branch: "trunk"

  livecheck do
    url "https://ftp.math.utah.edu/pub/tex/historic/systems/texlive/"
    regex(/href=.*?texlive[._-]v?(\d+(?:\.\d+)*)[._-]source\.t/i)
    strategy :page_match do |page, regex|
      # Match years from directories
      years = page.scan(%r{href=["']?v?(\d+(?:\.\d+)*)/?["' >]}i)
                  .flatten
                  .uniq
                  .map { |v| Version.new(v) }
                  .sort
      next if years.blank?

      # Fetch the page for the newest year directory
      newest_year = years.last.to_s
      year_page = Homebrew::Livecheck::Strategy.page_content(URI.join(@url, newest_year).to_s)
      next if year_page[:content].blank?

      # Match version from source tarball filenames
      year_page[:content].scan(regex).flatten
    end
  end

  bottle do
    sha256 arm64_sonoma:   "a3a31bbb1d9bc1e9d373b9674f9f9e430715cc4dde6163e4a74c258c8fe000c0"
    sha256 arm64_ventura:  "7c4424d7dbda8aa023b5a4c4d07ddf604ccf872a2241967bae24c3b05e65e08c"
    sha256 arm64_monterey: "42560a30b4731c8db5f74e6bbefb17075b68aba0c83899733c703997f62f6b33"
    sha256 arm64_big_sur:  "091fa3f73856f3c2fdffb6402925de126c1773ec734c90700d27af6c791849ea"
    sha256 sonoma:         "72d4f3997dddf64b72fa3937cc1bf5f3587ac4a010a4a8c460f6fb829b8d5731"
    sha256 ventura:        "3b82d7b12355a116decb003b11ab06f2e65c582ba83daa0d20c187c0320f91dc"
    sha256 monterey:       "9e82bafde878de14292757dfe00038d03f500639ee873d22da31a5fc7bd81882"
    sha256 big_sur:        "8618d95d4161d83e59e2ea99d35c5cb389789d48ba2227a5bcb578d963c98b20"
    sha256 x86_64_linux:   "7c68fa0c6ba0f08acf5af865cecd5dd5f1f822438cd6e9bfb38e866163416d0b"
  end

  depends_on "pkg-config" => :build
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
  depends_on "luajit"
  depends_on "mpfr"
  depends_on "openjdk"
  depends_on "openssl@3"
  depends_on "perl"
  depends_on "pixman"
  depends_on "potrace"
  depends_on "pstoedit"
  depends_on "pygments"
  depends_on "python@3.11"

  uses_from_macos "icu4c"
  uses_from_macos "ncurses"
  uses_from_macos "ruby"
  uses_from_macos "tcl-tk"
  uses_from_macos "zlib"

  on_linux do
    depends_on "libice"
    depends_on "libnsl"
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
    url "https://ftp.math.utah.edu/pub/tex/historic/systems/texlive/2023/texlive-20230313-extra.tar.xz"
    mirror "https://ftp.tu-chemnitz.de/pub/tug/historic/systems/texlive/2023/texlive-20230313-extra.tar.xz"
    sha256 "80a676facc174e6853550c87898a982c96dfc63ac30de19e6fcaa7635edb38c2"
  end

  resource "install-tl" do
    url "https://ftp.math.utah.edu/pub/tex/historic/systems/texlive/2023/install-tl-unx.tar.gz"
    mirror "https://ftp.tu-chemnitz.de/pub/tug/historic/systems/texlive/2023/install-tl-unx.tar.gz"
    sha256 "d97bdb3b1903428e56373e70861b24db448243d74d950cdff96f4e888f008605"
  end

  resource "texlive-texmf" do
    url "https://ftp.math.utah.edu/pub/tex/historic/systems/texlive/2023/texlive-20230313-texmf.tar.xz"
    mirror "https://ftp.tu-chemnitz.de/pub/tug/historic/systems/texlive/2023/texlive-20230313-texmf.tar.xz"
    sha256 "4c4dc77a025acaad90fb6140db2802cdb7ca7a9a2332b5e3d66aa77c43a81253"
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
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/URI-5.12.tar.gz"
    sha256 "66abe0eaddd76b74801ecd28ec1411605887550fc0a45ef6aa744fdad768d9b3"
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
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Message-6.37.tar.gz"
    sha256 "0e59da0a85e248831327ebfba66796314cb69f1bfeeff7a9da44ad766d07d802"
  end

  resource "HTML::Tagset" do
    url "https://cpan.metacpan.org/authors/id/P/PE/PETDANCE/HTML-Tagset-3.20.tar.gz"
    sha256 "adb17dac9e36cd011f5243881c9739417fd102fce760f8de4e9be4c7131108e2"
  end

  resource "HTML::Parser" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTML-Parser-3.78.tar.gz"
    sha256 "22564002f206af94c1dd8535f02b0d9735125d9ebe89dd0ff9cd6c000e29c29d"
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
    url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/File-Listing-6.15.tar.gz"
    sha256 "46c4fb9f9eb9635805e26b7ea55b54455e47302758a10ed2a0b92f392713770c"
  end

  resource "HTTP::Cookies" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Cookies-6.10.tar.gz"
    sha256 "e36f36633c5ce6b5e4b876ffcf74787cc5efe0736dd7f487bdd73c14f0bd7007"
  end

  resource "HTTP::Daemon" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Daemon-6.14.tar.gz"
    sha256 "f0767e7f3cbb80b21313c761f07ad8ed253bce9fa2d0ba806b3fb72d309b2e1d"
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
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/libwww-perl-6.67.tar.gz"
    sha256 "96eec40a3fd0aa1bd834117be5eb21c438f73094d861a1a7e5774f0b1226b723"
  end

  resource "CGI" do
    url "https://cpan.metacpan.org/authors/id/L/LE/LEEJO/CGI-4.54.tar.gz"
    sha256 "9608a044ae2e87cefae8e69b113e3828552ddaba0d596a02f9954c6ac17fa294"
  end

  resource "HTML::Form" do
    url "https://cpan.metacpan.org/authors/id/S/SI/SIMBABQUE/HTML-Form-6.10.tar.gz"
    sha256 "df8393e35e495a0839f06a63fb65d6922842c180d260554137728a9f092df9d3"
  end

  resource "HTTP::Server::Simple" do
    url "https://cpan.metacpan.org/authors/id/B/BP/BPS/HTTP-Server-Simple-0.52.tar.gz"
    sha256 "d8939fa4f12bd6b8c043537fd0bf96b055ac3686b9cdd9fa773dca6ae679cb4c"
  end

  resource "WWW::Mechanize" do
    url "https://cpan.metacpan.org/authors/id/S/SI/SIMBABQUE/WWW-Mechanize-2.15.tar.gz"
    sha256 "91d0dc3235027d19fc485e93833ec92497bc508e31d391eb07ee664f988ca9b3"
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

  def install
    python3 = "python3.11"
    # Install Perl resources
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    ENV["PERL_MM_USE_DEFAULT"] = "1"
    ENV["OPENSSL_PREFIX"] = Formula["openssl@3"].opt_prefix

    tex_resources = %w[texlive-extra install-tl texlive-texmf]

    resources.each do |r|
      r.stage do
        next if tex_resources.include? r.name

        if File.exist? "Makefile.PL"
          args = ["INSTALL_BASE=#{libexec}"]
          args += ["X11INC=#{HOMEBREW_PREFIX}/include", "X11LIB=#{HOMEBREW_PREFIX}/lib"] if r.name == "Tk"

          system "perl", "Makefile.PL", *args
          system "make"
          system "make", "install"
        else
          system "perl", "Build.PL", "--install_base", libexec
          system "./Build"
          system "./Build", "install"
        end
      end
    end

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
    python_path = libexec/Language::Python.site_packages(python3)
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
    with_env(LUATEXDIR: share/"texmf-dist/scripts/context/lua") do
      system "luatex", "--luaonly", "mtxrun.lua", "--generate"
    end
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
      The beautiful equation \\ref{eu_eqn} is known as Euler's identity.

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

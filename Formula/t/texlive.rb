class Texlive < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "Free software distribution for the TeX typesetting system"
  homepage "https://www.tug.org/texlive/"
  url "https://ftp.math.utah.edu/pub/tex/historic/systems/texlive/2026/texlive-20260301-source.tar.xz"
  mirror "https://ftp.tu-chemnitz.de/pub/tug/historic/systems/texlive/2026/texlive-20260301-source.tar.xz"
  sha256 "cb120d314d3ceb23ac608af17ddd2c623afcf02331f400a0f25eead5b8ac1d70"
  license :cannot_represent
  compatibility_version 1
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

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 arm64_tahoe:   "107a9d90dadaa539a2b81965d616c213b85884e3ac11b664590cd7499d75aa3d"
    sha256 arm64_sequoia: "f95f28f08b5ad97dabcc0ff674a2ba2628cd28a9cb72e4479028057a63afb82d"
    sha256 arm64_sonoma:  "d0ec9ff9f399284628612edf2dffd3d962272d380216a5425d16faf28086919d"
    sha256 sonoma:        "457d840d2e97cea5f8a11e46adc9ade67c3e197b54875889033638b143222508"
    sha256 arm64_linux:   "f04609a0e06b0385278649da3408e8229296ef12d481d32632f564b20d3f94cc"
    sha256 x86_64_linux:  "4ab2674e0c636ab1cd8c8428ebcac12509976bd881f83853d08310aaab23cf33"
  end

  depends_on "pkgconf" => :build
  depends_on "cairo"
  depends_on "clisp"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "gd"
  depends_on "ghostscript"
  depends_on "gmp"
  depends_on "graphite2"
  depends_on "harfbuzz"
  depends_on "icu4c@78"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libx11"
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
  depends_on "python@3.14"
  depends_on "tcl-tk"

  uses_from_macos "ncurses"
  uses_from_macos "ruby"

  on_linux do
    depends_on "libice"
    depends_on "libnsl"
    depends_on "libsm"
    depends_on "libxaw"
    depends_on "libxext"
    depends_on "libxi"
    depends_on "libxmu"
    depends_on "libxpm"
    depends_on "libxt"
    depends_on "mesa"
    depends_on "zlib-ng-compat"
  end

  conflicts_with "cweb", because: "both install `cweb` binaries"
  conflicts_with "lcdf-typetools", because: "both install a `cfftot1` executable"
  conflicts_with "ht", because: "both install `ht` binaries"
  conflicts_with "opendetex", because: "both install `detex` binaries"

  resource "texlive-extra" do
    url "https://ftp.math.utah.edu/pub/tex/historic/systems/texlive/2026/texlive-20260301-extra.tar.xz"
    mirror "https://ftp.tu-chemnitz.de/pub/tug/historic/systems/texlive/2026/texlive-20260301-extra.tar.xz"
    sha256 "68d78428d012bce8c2ffaf7027c701a66c51039a16059d33f30980330033a5d0"
  end

  resource "install-tl" do
    url "https://ftp.math.utah.edu/pub/tex/historic/systems/texlive/2026/install-tl-unx.tar.gz"
    mirror "https://ftp.tu-chemnitz.de/pub/tug/historic/systems/texlive/2026/install-tl-unx.tar.gz"
    sha256 "5cc0703d6fe49f00a2932c4e3bcee37a11cc0a969ae9fcbf9cad6f0d984d6363"
  end

  resource "texlive-texmf" do
    url "https://ftp.math.utah.edu/pub/tex/historic/systems/texlive/2026/texlive-20260301-texmf.tar.xz"
    mirror "https://ftp.tu-chemnitz.de/pub/tug/historic/systems/texlive/2026/texlive-20260301-texmf.tar.xz"
    sha256 "349eb7c5c2c15333d77490a52934b053c6dcb88834f2224978f7a4edf67940e7"
  end

  resource "Module::Build" do
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/Module-Build-0.4234.tar.gz"
    sha256 "66aeac6127418be5e471ead3744648c766bd01482825c5b66652675f2bc86a8f"
  end

  resource "ExtUtils::Config" do
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/ExtUtils-Config-0.010.tar.gz"
    sha256 "82e7e4e90cbe380e152f5de6e3e403746982d502dd30197a123652e46610c66d"
  end

  resource "ExtUtils::Helpers" do
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/ExtUtils-Helpers-0.028.tar.gz"
    sha256 "c8574875cce073e7dc5345a7b06d502e52044d68894f9160203fcaab379514fe"
  end

  resource "ExtUtils::InstallPaths" do
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/ExtUtils-InstallPaths-0.015.tar.gz"
    sha256 "7d64eb2dfa87ead010cdf55c8a1bdfde50b7b5852d7cb8cf2304f55bea2eb007"
  end

  resource "Module::Build::Tiny" do
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/Module-Build-Tiny-0.052.tar.gz"
    sha256 "bd10452c9f24d4b4fe594126e3ad231bab6cebf16acda40a4e8dc784907eb87f"
  end

  resource "Digest::SHA1" do
    url "https://cpan.metacpan.org/authors/id/G/GA/GAAS/Digest-SHA1-2.13.tar.gz"
    sha256 "68c1dac2187421f0eb7abf71452a06f190181b8fc4b28ededf5b90296fb943cc"
  end

  resource "Try::Tiny" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/Try-Tiny-0.32.tar.gz"
    sha256 "ef2d6cab0bad18e3ab1c4e6125cc5f695c7e459899f512451c8fa3ef83fa7fc0"
  end

  resource "Path::Tiny" do
    url "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/Path-Tiny-0.150.tar.gz"
    sha256 "ff20713d1a14d257af9c78209001f40dc177e4b9d1496115cbd8726d577946c7"
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
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/URI-5.34.tar.gz"
    sha256 "de64c779a212ff1821896c5ca2bb69e74767d2674cee411e777deea7a22604a8"
  end

  resource "TimeDate" do
    url "https://cpan.metacpan.org/authors/id/A/AT/ATOOMIC/TimeDate-2.34.tar.gz"
    sha256 "4571da8fad4393e7051be0098bd3ad028b3c60c2d75adf88b1f81b912154d6d2"
  end

  resource "Crypt::RC4" do
    url "https://cpan.metacpan.org/authors/id/S/SI/SIFUKURT/Crypt-RC4-2.02.tar.gz"
    sha256 "5ec4425c6bc22207889630be7350d99686e62a44c6136960110203cd594ae0ea"
  end

  resource "Digest::Perl::MD5" do
    url "https://cpan.metacpan.org/authors/id/D/DE/DELTA/Digest-Perl-MD5-1.91.tar.gz"
    sha256 "718e41717fb82a9ab3f0809d211fddcdbdef91dc198887d82b88723aa54afcd5"
  end

  resource "IO::Scalar" do
    url "https://cpan.metacpan.org/authors/id/C/CA/CAPOEIRAB/IO-Stringy-2.113.tar.gz"
    sha256 "51220fcaf9f66a639b69d251d7b0757bf4202f4f9debd45bdd341a6aca62fe4e"
  end

  resource "OLE::Storage_Lite" do
    url "https://cpan.metacpan.org/authors/id/J/JM/JMCNAMARA/OLE-Storage_Lite-0.24.tar.gz"
    sha256 "71c3b6ef082176c9585e620dd48f0f4782c282be73f2a653ea4b618f757bb3fd"
  end

  resource "Spreadsheet::ParseExcel" do
    url "https://cpan.metacpan.org/authors/id/J/JM/JMCNAMARA/Spreadsheet-ParseExcel-0.66.tar.gz"
    sha256 "bfd76acfba988601dc051bda73b4bb25f6839a006dd960b6a7401c249245f65b"
  end

  resource "Encode::Locale" do
    url "https://cpan.metacpan.org/authors/id/G/GA/GAAS/Encode-Locale-1.05.tar.gz"
    sha256 "176fa02771f542a4efb1dbc2a4c928e8f4391bf4078473bd6040d8f11adb0ec1"
  end

  resource "HTTP::Date" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Date-6.06.tar.gz"
    sha256 "7b685191c6acc3e773d1fc02c95ee1f9fae94f77783175f5e78c181cc92d2b52"
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
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Message-7.01.tar.gz"
    sha256 "82b79ce680251045c244ee059626fecbf98270bed1467f0175ff5ea91071437e"
  end

  resource "HTML::Tagset" do
    url "https://cpan.metacpan.org/authors/id/P/PE/PETDANCE/HTML-Tagset-3.24.tar.gz"
    sha256 "eb89e145a608ed1f8f141a57472ee5f69e67592a432dcd2e8b1dbb445f2b230b"
  end

  resource "HTML::Parser" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTML-Parser-3.83.tar.gz"
    sha256 "7278ce9791256132b26a71a5719451844704bb9674b58302c3486df43584f8c0"
  end

  resource "HTML::TreeBuilder" do
    url "https://cpan.metacpan.org/authors/id/K/KE/KENTNL/HTML-Tree-5.07.tar.gz"
    sha256 "f0374db84731c204b86c1d5b90975fef0d30a86bd9def919343e554e31a9dbbf"
  end

  resource "File::Slurper" do
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/File-Slurper-0.014.tar.gz"
    sha256 "d5a36487339888c3cd758e648160ee1d70eb4153cacbaff57846dbcefb344b0c"
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
    url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/File-Listing-6.16.tar.gz"
    sha256 "189b3a13fc0a1ba412b9d9ec5901e9e5e444cc746b9f0156d4399370d33655c6"
  end

  resource "HTTP::Cookies" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Cookies-6.11.tar.gz"
    sha256 "8c9a541a4a39f6c0c7e3d0b700b05dfdb830bd490a1b1942a7dedd1b50d9a8c8"
  end

  resource "HTTP::Daemon" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Daemon-6.16.tar.gz"
    sha256 "b38d092725e6fa4e0c4dc2a47e157070491bafa0dbe16c78a358e806aa7e173d"
  end

  resource "HTTP::Negotiate" do
    url "https://cpan.metacpan.org/authors/id/G/GA/GAAS/HTTP-Negotiate-6.01.tar.gz"
    sha256 "1c729c1ea63100e878405cda7d66f9adfd3ed4f1d6cacaca0ee9152df728e016"
  end

  resource "Net::HTTP" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/Net-HTTP-6.24.tar.gz"
    sha256 "290ed9a97b05c7935b048e6d2a356035871fca98ad72c01c5961726adf85c83c"
  end

  resource "WWW::RobotRules" do
    url "https://cpan.metacpan.org/authors/id/G/GA/GAAS/WWW-RobotRules-6.02.tar.gz"
    sha256 "46b502e7a288d559429891eeb5d979461dd3ecc6a5c491ead85d165b6e03a51e"
  end

  resource "LWP" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/libwww-perl-6.81.tar.gz"
    sha256 "ab30552f194e8b5ae3ac0885132fd1d4ea04c4c7fe6555765b98f01af70c1736"
  end

  resource "CGI" do
    url "https://cpan.metacpan.org/authors/id/L/LE/LEEJO/CGI-4.71.tar.gz"
    sha256 "9da85b30d9404d183da7ca7aedb83702cb07ed73c3078bf6f36c87f1e8a0196a"
  end

  resource "HTML::Form" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTML-Form-6.13.tar.gz"
    sha256 "ae5ad0f6fe70b1a382789d5e83a9b669cc541ee9d459e1bfa89b43ae0c014cdd"
  end

  resource "HTTP::Server::Simple" do
    url "https://cpan.metacpan.org/authors/id/B/BP/BPS/HTTP-Server-Simple-0.52.tar.gz"
    sha256 "d8939fa4f12bd6b8c043537fd0bf96b055ac3686b9cdd9fa773dca6ae679cb4c"
  end

  resource "WWW::Mechanize" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/WWW-Mechanize-2.20.tar.gz"
    sha256 "5adce695f3968565d3c8e597b988525ee4c89f40ecb1a21ecee7a16532dbb668"
  end

  resource "Mozilla::CA" do
    url "https://cpan.metacpan.org/authors/id/L/LW/LWP/Mozilla-CA-20250602.tar.gz"
    sha256 "adeac0752440b2da094e8036bab6c857e22172457658868f5ac364f0c7b35481"
  end

  resource "Net::SSLeay" do
    url "https://cpan.metacpan.org/authors/id/C/CH/CHRISN/Net-SSLeay-1.94.tar.gz"
    sha256 "9d7be8a56d1bedda05c425306cc504ba134307e0c09bda4a788c98744ebcd95d"
  end

  resource "IO::Socket::SSL" do
    url "https://cpan.metacpan.org/authors/id/S/SU/SULLR/IO-Socket-SSL-2.098.tar.gz"
    sha256 "b38473be20256b1a06447dd6769ad162bfad6a258234ed2c7e2e1819c16c4df7"
  end

  resource "LWP::Protocol::https" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/LWP-Protocol-https-6.15.tar.gz"
    sha256 "44eec2da147ba0511090871b0ca82f69794376bc31e8c76d1040961ba57f59b8"
  end

  resource "Tk" do
    url "https://cpan.metacpan.org/authors/id/S/SR/SREZIC/Tk-804.036.tar.gz"
    sha256 "32aa7271a6bdfedc3330119b3825daddd0aa4b5c936f84ad74eabb932a200a5e"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  def install
    python3 = "python3.14"
    venv = virtualenv_create(libexec, python3)
    venv.pip_install resource("pygments")

    # Install Perl resources
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    ENV["PERL_MM_USE_DEFAULT"] = "1"
    ENV["OPENSSL_PREFIX"] = Formula["openssl@3"].opt_prefix

    tex_resources = %w[texlive-extra install-tl texlive-texmf]

    resources.each do |r|
      next if tex_resources.include? r.name
      next if r.name == "pygments"

      r.stage do
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
    rm_r(share/"texmf-dist/doc")
    rm_r(share/"tlpkg/installer/wget")
    rm_r(share/"tlpkg/installer/xz")

    # Set up config files to use the correct path for the TeXLive root
    inreplace buildpath/"texk/kpathsea/texmf.cnf",
              "TEXMFROOT = $SELFAUTOPARENT", "TEXMFROOT = $SELFAUTODIR/share"
    inreplace share/"texmf-dist/web2c/texmfcnf.lua",
              "selfautoparent:texmf", "selfautodir:share/texmf"

    # icu4c 75+ needs C++17
    # TODO: Remove in 2025 release
    ENV.append "CXXFLAGS", "-std=gnu++17"

    # Work around build failure on Intel Sonoma after updating to Xcode 16
    # sh: line 1: 27478 Segmentation fault: 11  luajittex -ini -jobname=luajittex -progname=luajittex luatex.ini ...
    ENV.O1 if DevelopmentTools.clang_build_version == 1600 && Hardware::CPU.intel?

    args = [
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
    args << "--with-banner-add=/#{tap.user}" if tap

    args << if OS.mac?
      "--without-x"
    else
      # Make sure xdvi uses xaw, even if motif is available
      "--with-xdvi-x-toolkit=xaw"
    end

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
    system "make", "texlinks"

    # Create tlmgr config file.  This file limits the actions that the user
    # can perform in 'system' mode, which would write to the cellar.  'tlmgr' should
    # be used with --usermode whenever possible.
    actions = %w[
      candidates
      check
      dump-tlpdb
      help
      info
      init-usertree
      list
      print-platform
      print-platform-info
      search
      show
      version
    ]
    (share/"texmf-config/tlmgr/config").write "allowed-actions=#{actions.join(",")}\n"

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
    ENV.prepend_path "PYTHONPATH", venv.site_packages
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

    # Work around 20260301 format generation failure:
    # fmtutil [ERROR]: no (or empty) hilatex.fmt made by hitex.
    inreplace share/"texmf-dist/web2c/fmtutil.cnf",
              "hilatex hitex language.dat -etex -ltx hilatex.ini",
              "# hilatex hitex language.dat -etex -ltx hilatex.ini"

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

    (testpath/"test.latex").write <<~'LATEX'
      \documentclass[12pt]{article}
      \usepackage[utf8]{inputenc}
      \usepackage{amsmath}
      \usepackage{lipsum}

      \title{\LaTeX\ test}
      \author{\TeX\ Team}
      \date{September 2021}

      \begin{document}

      \maketitle

      \section*{An equation with amsmath}
      \begin{equation} \label{eu_eqn}
      e^{\pi i} + 1 = 0
      \end{equation}
      The beautiful equation \ref{eu_eqn} is known as Euler's identity.

      \section*{Lorem Ipsum}
      \lipsum[3]

      \lipsum[5]

      \end{document}
    LATEX

    assert_match "Output written on test.dvi", shell_output("#{bin}/latex #{testpath}/test.latex")
    assert_path_exists testpath/"test.dvi"
    assert_match "Output written on test.pdf", shell_output("#{bin}/pdflatex #{testpath}/test.latex")
    assert_path_exists testpath/"test.pdf"
    assert_match "This is dvips", shell_output("#{bin}/dvips #{testpath}/test.dvi 2>&1")
    assert_path_exists testpath/"test.ps"
  end
end

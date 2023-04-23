class Sqitch < Formula
  desc       "Sensible database change management"
  homepage   "https://sqitch.org/"
  url        "https://www.cpan.org/authors/id/D/DW/DWHEELER/App-Sqitch-v1.3.1.tar.gz"
  sha256     "f5e768d298cd4047ee2ae42319782e8c2cda312737bcbdbfaf580bd47efe8b94"
  license    "MIT"
  head       "https://github.com/sqitchers/sqitch.git", branch: "develop"

  depends_on "cpm" => :build
  depends_on "libiodbc"
  depends_on "libpq"
  depends_on "mysql-client"
  depends_on "perl"
  uses_from_macos "sqlite"

  if build.head?
    depends_on "gettext" => :build
    depends_on "openssl@3" => :build
  end

  def install
    # Download Module::Build and Menlo::CLI::Compat.
    cpm_args = %w[install --local-lib-contained instutil --no-test]
    cpm_args.push("--verbose") if verbose?
    system "cpm", *cpm_args, "Menlo::CLI::Compat", "Module::Build"

    ENV["PERL5LIB"] = "#{buildpath}/instutil/lib/perl5"
    ENV["PERL_MM_OPT"] = "INSTALLDIRS=vendor"
    ENV["PERL_MB_OPT"] = "--installdirs vendor"

    if build.head?
      # Need to tell the compiler where to find Gettext.
      ENV.prepend_path "PATH", Formula["gettext"].opt_bin

      # Download Dist::Zilla and plugins, then make and cd into a build dir.
      system "cpm", *cpm_args, "Dist::Zilla"
      system "./instutil/bin/dzil authordeps --missing | xargs cpm " + cpm_args.join(" ")
      system "./instutil/bin/dzil", "build", "--in", ".brew"
      Dir.chdir ".brew"
    end

    # Assemble the Build.PL args, including supported native and ODBC engines.
    # Oracle and Firebird not currently supported.
    args = %W[
      Build.PL --install_base #{prefix} --etcdir #{etc}/sqitch
      --with postgres --with sqlite --with mysql
      --with vertica --with exasol --with snowflake
    ]
    args.push("--verbose") if verbose?
    args.push("--quiet") if quiet?

    # Build and bundle (install).
    system "perl", *args
    system "./Build", "bundle"

    # Wrap the binary in client paths.
    mkdir_p libexec
    mv bin/"sqitch", libexec/"sqitch"
    paths = [
      Formula["libpq"].opt_bin,
      Formula["mysql-client"],
    ]
    (bin/"sqitch").write_env_script libexec/"sqitch", PATH: "#{paths.join(":")}:$PATH"

    # Move the man pages from #{prefix}/man to man.
    mkdir share
    mv "#{prefix}/man", man
  end

  def caveats
    <<~EOS
      This Sqitch install includes clients to manage Postgres, MySQL, and SQLite.
      See https://sqitch.org/download/macos/ to install the client libraries
      required to manage Snowflake, Exasol, and Vertica. Use the sqitchers/sqitch
      tap to manage Oracle or Firebird.
    EOS
  end

  test do
    system bin/"sqitch", "--version"
  end
end

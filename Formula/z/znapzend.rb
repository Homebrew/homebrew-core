class Znapzend < Formula
  desc "ZFS backup with remote capabilities and mbuffer integration"
  homepage "https://www.znapzend.org/"
  url "https://github.com/oetiker/znapzend/releases/download/v0.23.6/znapzend-0.23.6.tar.gz"
  sha256 "2b8903544b4013e3f059afa4812d20bc9d889d7ffda5a8fc5b7728f36599767a"
  license "GPL-3.0-or-later"
  head "https://github.com/oetiker/znapzend.git", branch: "master"

  # The `stable` URL uses a download from the GitHub release, so the release
  # needs to exist before the formula can be version bumped. It's more
  # appropriate to check the GitHub releases instead of tags in this context.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "051815a5a7dc66b5b31187d81767ccd4f49d213e4816311222b186d583c21a91"
  end

  depends_on "pod2man" => :build # generate same manpage on all OS
  uses_from_macos "perl"

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
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/Module-Build-Tiny-0.053.tar.gz"
    sha256 "3726d622da6f655e88fdf89e4fd597709c44970b47de65082003e8d86b5e193a"
  end

  resource "Class::Method::Modifiers" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/Class-Method-Modifiers-2.15.tar.gz"
    sha256 "65cd85bfe475d066e9186f7a8cc636070985b30b0ebb1cde8681cf062c2e15fc"
  end

  resource "Role::Tiny" do
    url "https://cpan.metacpan.org/authors/id/H/HA/HAARG/Role-Tiny-2.002005.tar.gz"
    sha256 "4618ec524618c104dc28a8cc86af129a00cad282aea7f4c75060ba05d4c8f4d7"
  end

  resource "Mojolicious" do
    url "https://cpan.metacpan.org/authors/id/S/SR/SRI/Mojolicious-9.53.tar.gz"
    sha256 "7a1417d6183929e274885c81e109e3a331c059c33ce1824929c1de81d9fe73bf"
  end

  resource "Mojo::Log::Role::Clearable" do
    url "https://cpan.metacpan.org/authors/id/D/DB/DBOOK/Mojo-Log-Clearable-1.001.tar.gz"
    sha256 "82e06a29d59e99ce260bfc69efb59deea795da246a638c2b439351b07b6c0a72"
  end

  deny_network_access!

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    resources.each do |r|
      r.stage do
        if File.exist? "Makefile.PL"
          system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}",
                                        "INSTALLMAN1DIR=none",
                                        "INSTALLMAN3DIR=none",
                                        "NO_PACKLIST=1",
                                        "NO_PERLLOCAL=1"
          system "make", "install"
        else
          system "perl", "Build.PL", "--create_packlist=0",
                                     "--install_base", libexec,
                                     "--install_path", "libdoc=none"
          system "./Build"
          system "./Build", "install"
        end
      end
    end

    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install", "SUBDIRS=lib"
    (var/"log/znapzend").mkpath
  end

  service do
    run [opt_bin/"znapzend", "--connectTimeout=120", "--logto=#{var}/log/znapzend/znapzend.log"]
    environment_variables PATH: std_service_path_env
    keep_alive true
    require_root true
    error_log_path var/"log/znapzend.err.log"
    log_path var/"log/znapzend.out.log"
    working_dir var/"run/znapzend"
  end

  test do
    fake_zfs = testpath/"zfs"
    fake_zfs.write <<~SH
      #!/bin/sh
      for word in "$@"; do echo $word; done >> znapzendzetup_said.txt
      exit 0
    SH
    chmod 0755, fake_zfs
    ENV.prepend_path "PATH", testpath

    system bin/"znapzendzetup", "list"

    assert_equal <<~EOS, (testpath/"znapzendzetup_said.txt").read
      list
      -H
      -o
      name
      -t
      filesystem,volume
    EOS
  end
end

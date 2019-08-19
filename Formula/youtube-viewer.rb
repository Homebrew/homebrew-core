class YoutubeViewer < Formula
  desc "Lightweight app for searching and streaming videos from YouTube"
  homepage "https://trizenx.blogspot.com/2012/03/gtk-youtube-viewer.html"
  url "https://github.com/trizen/youtube-viewer/archive/3.5.6.tar.gz"
  sha256 "b4d2d17e3ff8aba5f3c358db170867d89ca5e35f3340312c81b9af7c70f3c826"
  head "https://github.com/trizen/youtube-viewer.git"

  # build deps
  resource "inc::latest" do
    url "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/inc-latest-0.500.tar.gz"
    sha256 "daa905f363c6a748deb7c408473870563fcac79b9e3e95b26e130a4a8dc3c611"
  end

  resource "TAP::Harness" do
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/Test-Harness-3.42.tar.gz"
    sha256 "0fd90d4efea82d6e262e6933759e85d27cbcfa4091b14bf4042ae20bab528e53"
  end

  resource "CPAN::Meta" do
    url "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/CPAN-Meta-2.143240.tar.gz"
    sha256 "c6d1aa77984154bf72bbca3ac30b6a092379ecd7fdc6d2ddc1addc0b6f5f00b5"
  end

  resource "Module::Build" do
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/Module-Build-0.4229.tar.gz"
    sha256 "1fe491a6cda914b01bc8e592faa2b5404e9f35915ca15322f8f2a8d8f9008c18"
  end

  # runtime deps, see: https://github.com/trizen/youtube-viewer/blob/master/META.json#L34-L53
  resource "Data::Dump" do
    url "https://cpan.metacpan.org/authors/id/G/GA/GAAS/Data-Dump-1.23.tar.gz"
    sha256 "af53b05ef1387b4cab4427e6789179283e4f0da8cf036e8db516ddb344512b65"
  end

  resource "Encode" do
    url "https://cpan.metacpan.org/authors/id/D/DA/DANKOGAI/Encode-3.01.tar.gz"
    sha256 "d4555f570491648dbbd602bce7966672834b4c8f45acaa6757de474fca3a4d87"
  end

  resource "File::Path" do
    url "https://cpan.metacpan.org/authors/id/J/JK/JKEENAN/File-Path-2.16.tar.gz"
    sha256 "21f7d69b59c381f459c5f0bf697d512109bd911f12ca33270b70ca9a9ef6fa05"
  end

  resource "File::Spec" do
    # N.B. also includes File::Spec::Functions
    url "https://cpan.metacpan.org/authors/id/X/XS/XSAWYERX/PathTools-3.75.tar.gz"
    sha256 "a558503aa6b1f8c727c0073339081a77888606aa701ada1ad62dd9d8c3f945a2"
  end

  resource "Getopt::Long" do
    url "https://cpan.metacpan.org/authors/id/J/JV/JV/Getopt-Long-2.51.tar.gz"
    sha256 "20b43b94c2f4096e9e05c213d6184d7391567f127631d69e9b1ffd994d4cc564"
  end

  resource "HTTP::Request" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Message-6.18.tar.gz"
    sha256 "d060d170d388b694c58c14f4d13ed908a2807f0e581146cef45726641d809112"
  end

  resource "JSON" do
    url "https://cpan.metacpan.org/authors/id/I/IS/ISHIGAKI/JSON-4.02.tar.gz"
    sha256 "444a88755a89ffa2a5424ab4ed1d11dca61808ebef57e81243424619a9e8627c"
  end

  resource "LWP::Protocol::https" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/LWP-Protocol-https-6.07.tar.gz"
    sha256 "522cc946cf84a1776304a5737a54b8822ec9e79b264d0ba0722a70473dbfb9e7"
  end

  resource "LWP::UserAgent" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/libwww-perl-6.39.tar.gz"
    sha256 "9a8d7747938aa75d7d524c71574ae7f99ca66a5dac8255a7f7759f373e7774d5"
  end

  resource "List::Util" do
    url "https://cpan.metacpan.org/authors/id/P/PE/PEVANS/Scalar-List-Utils-1.52.tar.gz"
    sha256 "279d78cef84acae280da4dfb95eff0c9865d1611b1a3b026baddf42d1ba01de4"
  end

  resource "MIME::Base64" do
    url "https://cpan.metacpan.org/authors/id/G/GA/GAAS/MIME-Base64-3.15.tar.gz"
    sha256 "7f863566a6a9cb93eda93beadb77d9aa04b9304d769cea3bb921b9a91b3a1eb9"
  end

  resource "Term::ANSIColor" do
    url "https://cpan.metacpan.org/authors/id/R/RR/RRA/Term-ANSIColor-4.06.tar.gz"
    sha256 "8161c7434b1984bde588d75f22c786c46cb6d35d264d58111db0b82537de4bad"
  end

  resource "Term::ReadLine" do
    url "https://cpan.metacpan.org/authors/id/F/FL/FLORA/Term-ReadLine-1.14.tar.gz"
    sha256 "54523c72b26a04608170849013a433ba400f66b4f9b0524201bfd37ff6e3c477"
  end

  resource "Text::ParseWords" do
    url "https://cpan.metacpan.org/authors/id/C/CH/CHORNY/Text-ParseWords-3.30.tar.gz"
    sha256 "85e0238179dd43997e58c66bd51611182bc7d533505029a2db0d3232edaff5e8"
  end

  resource "Text::Wrap" do
    url "https://cpan.metacpan.org/authors/id/M/MU/MUIR/modules/Text-Tabs+Wrap-2013.0523.tar.gz"
    sha256 "b9cb056fffb737b9c12862099b952bf4ab4b1f599fd34935356ae57dab6f655f"
  end

  resource "URI::Escape" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/URI-1.76.tar.gz"
    sha256 "b2c98e1d50d6f572483ee538a6f4ccc8d9185f91f0073fd8af7390898254413e"
  end

  # optional runtime deps
  resource "LWP::UserAgent::Cached" do
    url "https://cpan.metacpan.org/authors/id/O/OL/OLEG/LWP-UserAgent-Cached-0.07.tar.gz"
    sha256 "4a9cdc47e58560e39dd99a08d1dbddcbc998942ebcdc9deca6e2b220b0d86ae0"
  end

  resource "Mozilla::CA" do
    url "https://cpan.metacpan.org/authors/id/A/AB/ABH/Mozilla-CA-20180117.tar.gz"
    sha256 "f2cc9fbe119f756313f321e0d9f1fac0859f8f154ac9d75b1a264c1afdf4e406"
  end

  def install
    ENV.append "PERL_MM_USE_DEFAULT", 1
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make"
        system "make", "install"
      end
    end

    ENV.prepend_path "PATH", libexec/"bin"

    system "perl", "Build.PL", "--install_base", libexec
    system "./Build", "install"

    %w[youtube-viewer].each do |cmd|
      (bin/cmd).write_env_script(libexec/"bin/#{cmd}", :PERL5LIB => ENV["PERL5LIB"])
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/youtube-viewer --version").split(/ /)[2]
  end
end

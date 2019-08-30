class Skipfish < Formula
  desc "Web application security scanner"
  homepage "https://code.google.com/archive/p/skipfish/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/skipfish/skipfish-2.10b.tgz"
  sha256 "1a4fbc9d013f1f9b970946ea7228d943266127b7f4100c994ad26c82c5352a9e"
  revision 2

  bottle do
    rebuild 1
    sha256 "89109163ad7ff8d82869add5523737ea41704b330f3f4b0ddf9ee3f25ca562dd" => :mojave
    sha256 "b67e901534789b2e4438b4736dbcb7ca21d25e4aa3210869ff6e84eaca0f4c34" => :high_sierra
    sha256 "821c75cf8c8455482f47ae910bb867ceaac0546ca5af022efe9705e1d0c9830e" => :sierra
  end

  depends_on "libidn"
  depends_on "openssl" # no OpenSSL 1.1 support
  depends_on "pcre"

  def install
    ENV.append "CFLAGS", "-I#{HOMEBREW_PREFIX}/include"
    ENV.append "LDFLAGS", "-L#{HOMEBREW_PREFIX}/lib"

    chmod 0755, "src/config.h" # Not writeable in the tgz. Lame.
    inreplace "src/config.h",
      "#define ASSETS_DIR              \"assets\"",
      "#define ASSETS_DIR	       \"#{libexec}/assets\""

    system "make"
    bin.install "skipfish"
    libexec.install %w[assets dictionaries config signatures doc]
  end

  def caveats; <<~EOS
    NOTE: Skipfish uses dictionary-based probes and will not run until
    you have specified a dictionary for it to use. Please read:
      #{libexec}/doc/dictionaries.txt
    carefully to make the right choice. This step has a profound impact
    on the quality of results later on.

    Use this command to print usage information:
      skipfish -h
  EOS
  end
end

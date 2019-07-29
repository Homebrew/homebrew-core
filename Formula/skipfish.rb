class Skipfish < Formula
  desc "Web application security scanner"
  homepage "https://code.google.com/archive/p/skipfish/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/skipfish/skipfish-2.10b.tgz"
  sha256 "1a4fbc9d013f1f9b970946ea7228d943266127b7f4100c994ad26c82c5352a9e"
  revision 2

  bottle do
    sha256 "58930fa4ed6c9bb930b3e502826e674f6ef9d75c4cf9648d443326e46f09f77d" => :mojave
    sha256 "1acea16d96d52ba66c14f3194fb1c7d63f570e3f1ce5828458d28ddbc75d7d77" => :high_sierra
    sha256 "e3e89e094313db04248263b0a6d9901ea47254215219046b01c048584ee98f4d" => :sierra
    sha256 "60db8bcf08796a72afa621516767d0d0120a4ad305c6b8793b492f20b4679a71" => :el_capitan
  end

  depends_on "libidn"
  depends_on "openssl"
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

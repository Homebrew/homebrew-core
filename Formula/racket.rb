class Racket < Formula
  desc "Modern programming language in the Lisp/Scheme family"
  homepage "https://racket-lang.org/"
  url "https://mirror.racket-lang.org/installers/6.5/racket-minimal-6.5-src-builtpkgs.tgz"
  version "6.5"
  sha256 "44fe95a4ec4d442b4f6f68e360104ca9715bd1fe3795d302d6cddaceb15696dc"

  bottle do
    sha256 "d6ab6c4c623dd00a78a3ce158c836241b3478df747215f5d5364c6333f3fd213" => :el_capitan
    sha256 "c9fd1a5445576238a6dc0d5a486b211562a6206a2872397a9218aca115c8f111" => :yosemite
    sha256 "d7a76bd531b6f02e0beecc96bb3bf6ff48b30d8e19928ab3f78fd3abacd9206a" => :mavericks
  end

  # these two files are amended when (un)installing packages
  skip_clean "lib/racket/launchers.rktd", "lib/racket/mans.rktd"

  def install
    cd "src" do
      args = %W[
        --disable-debug
        --disable-dependency-tracking
        --enable-macprefix
        --prefix=#{prefix}
        --man=#{man}
        --sysconfdir=#{etc}
      ]

      args << "--disable-mac64" unless MacOS.prefer_64_bit?

      system "./configure", *args
      system "make"
      system "make", "install"
    end

    # configure racket's package tool (raco) to do the Right Thing
    # see: https://docs.racket-lang.org/raco/config-file.html
    inreplace etc/"racket/config.rktd" do |s|
      s.gsub!(
        /\(bin-dir\s+\.\s+"#{Regexp.quote(bin)}"\)/,
        "(bin-dir . \"#{HOMEBREW_PREFIX}/bin\")"
      )
      s.gsub!(
        /\n\)$/,
        "\n      (default-scope . \"installation\")\n)"
      )
    end
  end

  def caveats; <<-EOS.undent
    This is a minimal Racket distribution.
    If you want to build the DrRacket IDE, you may run
      raco pkg install --auto drracket

    The full Racket distribution is available as a cask:
      brew cask install racket
    EOS
  end

  test do
    output = shell_output("#{bin}/racket -e '(displayln \"Hello Homebrew\")'")
    assert_match /Hello Homebrew/, output

    # show that the config file isn't malformed
    output = shell_output("'#{bin}/raco' pkg config")
    assert $?.success?
    assert_match Regexp.new(<<-EOS.undent), output
      ^name:
        #{version}
      catalogs:
        https://download.racket-lang.org/releases/#{version}/catalog/
        https://pkgs.racket-lang.org
        https://planet-compats.racket-lang.org
      default-scope:
        installation
    EOS
  end
end

class Racket < Formula
  desc "Modern programming language in the Lisp/Scheme family"
  homepage "https://racket-lang.org/"
  url "https://mirror.racket-lang.org/installers/6.6/racket-minimal-6.6-src-builtpkgs.tgz"
  version "6.6"
  sha256 "f0666dbf0c7fc446f103b0c16eed508225addb09596f9c44a87b9d546422b1e9"

  bottle do
    sha256 "6b50bf5d15701b944b15e10114768001464cbd57835be58ae0545d1e9881b322" => :el_capitan
    sha256 "47eb9eab233c9bdc0faa0c81f966656314524c1a4464815dad245aba0ab1d24a" => :yosemite
    sha256 "bc214629b72c9604100d84dc1aae4ec80d2b39f9c3bb87b9f50d2d550ce2e9a9" => :mavericks
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

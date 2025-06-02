class Sbcl < Formula
  desc "Steel Bank Common Lisp system"
  homepage "https://www.sbcl.org/"
  url "https://downloads.sourceforge.net/project/sbcl/sbcl/2.5.4/sbcl-2.5.4-source.tar.bz2"
  sha256 "5f14b4ed92942a9e387594fac000b96db7467e9ce5613067ffc0923df3ec2072"
  license all_of: [:public_domain, "MIT", "Xerox", "BSD-3-Clause"]
  head "https://git.code.sf.net/p/sbcl/sbcl.git", branch: "master"

  livecheck do
    url "https://sourceforge.net/projects/sbcl/rss?path=/sbcl"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0ebd2441645846597297eb73683a060b671c8332ac921bda4cda7b1bdb30fab3"
    sha256 cellar: :any,                 arm64_sonoma:  "d282c46450690cc09484b421299590c253f39f7cdf9c7363b2cbc7164dc5f5e1"
    sha256 cellar: :any,                 arm64_ventura: "d25bd49c59fd5fbb6353f050da3d20b28fbaf6cd91acc419577788e2b350f833"
    sha256 cellar: :any,                 sonoma:        "194e8ad52afaee56eb6d279608b48f2f72a739583b708d4ed06c5c388dc69560"
    sha256 cellar: :any,                 ventura:       "ac18fb7ffda092860b7d5462d4afed66a5f6f3c82ba863d8ec6913b1daf9bbf7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "78b7be6f50234b6e224b86bb0f1019b2707393e3bb37cbe2e7166764cfc009d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a895b133040ca1c6ac064bd9a0bf4214fda25414154c80c9fbe7bac4bdb9990"
  end

  depends_on "ecl" => :build
  depends_on "zstd"

  def install
    # Remove non-ASCII values from environment as they cause build failures
    # More information: https://bugs.gentoo.org/show_bug.cgi?id=174702
    ENV.delete_if do |_, value|
      ascii_val = value.dup
      ascii_val.force_encoding("ASCII-8BIT") if ascii_val.respond_to? :force_encoding
      ascii_val =~ /[\x80-\xff]/n
    end

    xc_cmdline = "ecl --norc"

    args = [
      "--prefix=#{prefix}",
      "--xc-host=#{xc_cmdline}",
      "--with-sb-core-compression",
      "--with-sb-ldb",
      "--with-sb-thread",
    ]

    ENV["SBCL_MACOSX_VERSION_MIN"] = MacOS.version.to_s if OS.mac?
    system "./make.sh", *args

    ENV["INSTALL_ROOT"] = prefix
    system "sh", "install.sh"

    # Install sources
    bin.env_script_all_files libexec/"bin",
                             SBCL_SOURCE_ROOT: pkgshare/"src",
                             SBCL_HOME:        lib/"sbcl"
    pkgshare.install %w[contrib src]
    (lib/"sbcl/sbclrc").write <<~LISP
      (setf (logical-pathname-translations "SYS")
        '(("SYS:SRC;**;*.*.*" #p"#{pkgshare}/src/**/*.*")
          ("SYS:CONTRIB;**;*.*.*" #p"#{pkgshare}/contrib/**/*.*")))
    LISP
  end

  test do
    (testpath/"simple.sbcl").write <<~LISP
      (write-line (write-to-string (+ 2 2)))
    LISP
    output = shell_output("#{bin}/sbcl --script #{testpath}/simple.sbcl")
    assert_equal "4", output.strip
  end
end

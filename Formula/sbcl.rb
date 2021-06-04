class Sbcl < Formula
  desc "Steel Bank Common Lisp system"
  homepage "http://www.sbcl.org/"
  url "https://downloads.sourceforge.net/project/sbcl/sbcl/2.1.5/sbcl-2.1.5-source.tar.bz2"
  sha256 "965807ecd65a9590d68a0ed408b544e7e49a1f6e337ebd2b25e34788bcc8a8c5"
  license all_of: [:public_domain, "MIT", "Xerox", "BSD-3-Clause"]
  head "https://git.code.sf.net/p/sbcl/sbcl.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7523655e1644bfb47716c56adc4597d9ad914ea0e8569c6c9660363020793314"
    sha256 cellar: :any_skip_relocation, big_sur:       "dc95f64936ebf07065fa3ac6cbc9910aaab350c23f077486b76baa1e56bd7893"
    sha256 cellar: :any_skip_relocation, catalina:      "109ce34c2faed1b6357dad8c07b6e8dbc700e0408d8afd77683d9804e97a2fa3"
    sha256 cellar: :any_skip_relocation, mojave:        "665d2dd2ba9613ea902f7435592bf15868052eefe7d81127a4f7ca03b510d35c"
  end

  depends_on "ecl" => :build

  uses_from_macos "zlib"

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

    ENV["SBCL_MACOSX_VERSION_MIN"] = MacOS.version
    system "./make.sh", *args

    ENV["INSTALL_ROOT"] = prefix
    system "sh", "install.sh"

    # Install sources
    bin.env_script_all_files libexec/"bin",
                             SBCL_SOURCE_ROOT: pkgshare/"src",
                             SBCL_HOME:        lib/"sbcl"
    pkgshare.install %w[contrib src]
    (lib/"sbcl/sbclrc").write <<~EOS
      (setf (logical-pathname-translations "SYS")
        '(("SYS:SRC;**;*.*.*" #p"#{pkgshare}/src/**/*.*")
          ("SYS:CONTRIB;**;*.*.*" #p"#{pkgshare}/contrib/**/*.*")))
    EOS
  end

  test do
    (testpath/"simple.sbcl").write <<~EOS
      (write-line (write-to-string (+ 2 2)))
    EOS
    output = shell_output("#{bin}/sbcl --script #{testpath}/simple.sbcl")
    assert_equal "4", output.strip
  end
end

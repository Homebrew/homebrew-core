class Sbcl < Formula
  desc "Steel Bank Common Lisp system"
  homepage "http://www.sbcl.org/"
  url "https://downloads.sourceforge.net/project/sbcl/sbcl/2.3.2/sbcl-2.3.2-source.tar.bz2"
  sha256 "44cc162cfa6332a9a88c7a121d19038828a4ba4f6bffb77ef1c7b17407cb1eaa"
  license all_of: [:public_domain, "MIT", "Xerox", "BSD-3-Clause"]
  head "https://git.code.sf.net/p/sbcl/sbcl.git", branch: "master"

  livecheck do
    url "https://sourceforge.net/projects/sbcl/rss?path=/sbcl"
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "51931f3c3d05d14a84dfcda44dc46c9c2511830cf63482ccfa11c1b517ac66cb"
    sha256 cellar: :any,                 arm64_monterey: "751032f22a82c7629e86fbaa21ac03061e67c535d1570d620efcf57c255d8f63"
    sha256 cellar: :any,                 arm64_big_sur:  "e54b1bf3145afaf33e41a5ad7f0e5ee2652834ee53e9ac547af2b1f303f9be7d"
    sha256 cellar: :any,                 ventura:        "e2475e521f560bb11dd6bb09ffd9f05de393eba9f5911e48315d89263c057a02"
    sha256 cellar: :any,                 monterey:       "00daefba0a64187ddd20072a2820929c065f764d714720fb9d6e32408fd1622a"
    sha256 cellar: :any,                 big_sur:        "2dec047e8be3a967f12321e6d8f1be5b6999b7b116ccfef06567969d42a0d7a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81f5befee667ad2a465aa9c11d7e325717ef2c6284bee38df58a9cedec955eec"
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

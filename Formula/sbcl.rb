class Sbcl < Formula
  desc "Steel Bank Common Lisp system"
  homepage "http://www.sbcl.org/"
  url "https://downloads.sourceforge.net/project/sbcl/sbcl/2.3.3/sbcl-2.3.3-source.tar.bz2"
  sha256 "52e9a16f79a9bb4601ac09a6c76dfb90a7d643c9acff736b4293b2699f0150bf"
  license all_of: [:public_domain, "MIT", "Xerox", "BSD-3-Clause"]
  head "https://git.code.sf.net/p/sbcl/sbcl.git", branch: "master"

  livecheck do
    url "https://sourceforge.net/projects/sbcl/rss?path=/sbcl"
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "45fd398ae1be781857f343abc977bd711506b2803318c6314a3d268ed337f799"
    sha256 cellar: :any,                 arm64_monterey: "b433be51c526e2dfcfe308c26b01e05c468fdd39ba92b603483228fcb42a4dfb"
    sha256 cellar: :any,                 arm64_big_sur:  "1d6f592cf4749a08ee04d677db21a2d57ffa34f40b4562d0fd32d54a50d90d1f"
    sha256 cellar: :any,                 ventura:        "7b5cf5248c4319c53c0ec58770040c72d286bcbe146401e5fcc71ec516f77d14"
    sha256 cellar: :any,                 monterey:       "0169c3f1ed4c2289a43272c9c57a408d191e5c4a2cfac9b5fafa3cc3e2905ab5"
    sha256 cellar: :any,                 big_sur:        "398912d2c308f8be37b9db9df3215ac15bcc1b56c58589062570e0fa88eb0c79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7022cfa97652fe0a5157d3327fee2ee81fe92029d0d7fe4bfe25dbcfcf80d32b"
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

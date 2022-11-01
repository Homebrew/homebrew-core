class Sbcl < Formula
  desc "Steel Bank Common Lisp system"
  homepage "http://www.sbcl.org/"
  url "https://downloads.sourceforge.net/project/sbcl/sbcl/2.2.10/sbcl-2.2.10-source.tar.bz2"
  sha256 "8cc3c3a8761223adef144a88730b2675083a3b26fa155d70cf91abb935e90833"
  license all_of: [:public_domain, "MIT", "Xerox", "BSD-3-Clause"]
  head "https://git.code.sf.net/p/sbcl/sbcl.git", branch: "master"

  livecheck do
    url "https://sourceforge.net/projects/sbcl/rss?path=/sbcl"
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2b69d1a2cbe7ae55f403f11351a8eb97948e8b5e5cbba76c577c0b01f46be810"
    sha256 cellar: :any,                 arm64_big_sur:  "8e5becbf68466e0055f970153258fbc11ccef290bd2b9ec11e1566b00981861a"
    sha256 cellar: :any,                 monterey:       "08ceb2f905fba55983d3851af5b23fa940794b810bd4d6538b2c71f436b83629"
    sha256 cellar: :any,                 big_sur:        "15c45e72bbfdeee3c3c888c58e9e79f05d7121c3e4c48553751348058fb459a4"
    sha256 cellar: :any,                 catalina:       "c2cfcb89a28c6c04de8185f40e7acc004bb2d34e892272d9771e678072c2fffa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eaab47f875d930dbb9593074f46157b4a1f8950144d1479bd8a56ddba5002904"
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

class Sbcl < Formula
  desc "Steel Bank Common Lisp system"
  homepage "http://www.sbcl.org/"
  url "https://downloads.sourceforge.net/project/sbcl/sbcl/2.1.4/sbcl-2.1.4-source.tar.bz2"
  sha256 "99260e2346fcd22ae5546e15baf50899dcb3b75a6c74cc7cc849378899efbd11"
  license all_of: [:public_domain, "MIT", "Xerox", "BSD-3-Clause"]
  head "https://git.code.sf.net/p/sbcl/sbcl.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cf9727f5b19beaa928a474c0099f4d38522dd47ae86b56d829fbcef620ebc245"
    sha256 cellar: :any_skip_relocation, big_sur:       "019e21e1de33d751ccc8c1dd6e5dd7cd161d22016fce2624083ef3833189f8bf"
    sha256 cellar: :any_skip_relocation, catalina:      "ed4fdc4198a634f1d15e1887304a08faa2a1f515b5f8bcf91885f6c8f5854b20"
    sha256 cellar: :any_skip_relocation, mojave:        "1259d3e38d595738ef04bbd9ddbd6fd6adb3d002316bc5c540ff05568e2fa23b"
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

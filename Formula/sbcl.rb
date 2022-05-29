class Sbcl < Formula
  desc "Steel Bank Common Lisp system"
  homepage "http://www.sbcl.org/"
  url "https://downloads.sourceforge.net/project/sbcl/sbcl/2.2.4/sbcl-2.2.4-source.tar.bz2"
  sha256 "fcdd251cbc65f7f808ed0ad77246848d1be166aa69a17f7499600184b7a57202"
  license all_of: [:public_domain, "MIT", "Xerox", "BSD-3-Clause"]
  head "https://git.code.sf.net/p/sbcl/sbcl.git", branch: "master"

  livecheck do
    url "https://sourceforge.net/projects/sbcl/rss?path=/sbcl"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6d8c6243cd6fd92cf9fd681a3784d876c1be1a86083dc542dd9abc01f8e49ed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c4af4f35fafa713bb0cec53e4139667556586f65e444e5c06644a44683c36b76"
    sha256 cellar: :any_skip_relocation, monterey:       "69ce647fd052ffa06a88b075a2f6d89aca716a7e41c40592fd1e2f3dae50bccf"
    sha256 cellar: :any_skip_relocation, big_sur:        "80752428b30f1f51088d771a9e3ea473f027bf268f2087a279c30be1d5ae0c10"
    sha256 cellar: :any_skip_relocation, catalina:       "91db4a34003a7c7d4a9730f96eb93ab8ef61dd29feedd2c0ac75494ca2f2689f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c294f8ccd79f9a5e55f3d284250238ee2e50b27c4958691283e0b0671f0cd95c"
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

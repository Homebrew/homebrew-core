class Sbcl < Formula
  desc "Steel Bank Common Lisp system"
  homepage "http://www.sbcl.org/"
  license all_of: [:public_domain, "MIT", "Xerox", "BSD-3-Clause"]
  revision 1
  head "https://git.code.sf.net/p/sbcl/sbcl.git", shallow: false

  stable do
    url "https://downloads.sourceforge.net/project/sbcl/sbcl/2.0.11/sbcl-2.0.11-source.tar.bz2"
    sha256 "87d2aa53cef092119a1c8b2f3de48d209375a674c3b60e08596838013bd7971d"
    depends_on arch: :x86_64
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "e6a0d4ba798d435a261e93062461a15801a42af1cab9344cdeab824b00112318"
    sha256 cellar: :any_skip_relocation, catalina: "82afe9ba6dad370ba0895be28b3591eeae9bb88fbba93a916637cea1e6b140c3"
    sha256 cellar: :any_skip_relocation, mojave:   "a8eadb8a7b8a092995d0f29f4b68cf5450c070dd41bdf3f9f15e4907b516d48b"
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

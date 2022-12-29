class Sbcl < Formula
  desc "Steel Bank Common Lisp system"
  homepage "http://www.sbcl.org/"
  url "https://downloads.sourceforge.net/project/sbcl/sbcl/2.3.0/sbcl-2.3.0-source.tar.bz2"
  sha256 "bf743949712ae02cb7493f3b8b57ce241948bf61131e36860ddb334da1439c97"
  license all_of: [:public_domain, "MIT", "Xerox", "BSD-3-Clause"]
  head "https://git.code.sf.net/p/sbcl/sbcl.git", branch: "master"

  livecheck do
    url "https://sourceforge.net/projects/sbcl/rss?path=/sbcl"
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a2824e9cd22eb956d01f3450b1c68f6ad03d82b648ce67a370d67038f9e13566"
    sha256 cellar: :any,                 arm64_monterey: "6489be912e7d66df7742f0a800236f0c72247923fdae0177dcaef59d590ce706"
    sha256 cellar: :any,                 arm64_big_sur:  "5a8b09b68b1202f9bbd25b318fe50e87b8ccd92997f8f44e822725ddb4866891"
    sha256 cellar: :any,                 ventura:        "d7a77fd127bae842fc8d5c747dc1aac10544ad4ee941f994c430d8fc0483b12c"
    sha256 cellar: :any,                 monterey:       "3aaefeb38e3050c9372bff42f29261dbaf60a2fe30382c19d19c52269c675788"
    sha256 cellar: :any,                 big_sur:        "4fac61a5322a6ee65596fbf2a5c1d9a02bf37124ddf0f06dd995e59fed39b232"
    sha256 cellar: :any,                 catalina:       "9e4ede2503a93defc2d8da601d211d072dc56c7602ec20bcaeb5b1fb97e3feb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6c170a15f1b6cbfa3926dd3f6010e5f9ac81807cea1ebbbc4c3f0cdd3f01131"
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

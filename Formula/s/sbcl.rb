class Sbcl < Formula
  desc "Steel Bank Common Lisp system"
  homepage "https://www.sbcl.org/"
  url "https://downloads.sourceforge.net/project/sbcl/sbcl/2.5.1/sbcl-2.5.1-source.tar.bz2"
  sha256 "4133b36cd16d14d633969c37fd51c2c89a8ea5d6e1611552819d91f71b219f8b"
  license all_of: [:public_domain, "MIT", "Xerox", "BSD-3-Clause"]
  head "https://git.code.sf.net/p/sbcl/sbcl.git", branch: "master"

  livecheck do
    url "https://sourceforge.net/projects/sbcl/rss?path=/sbcl"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ff5ffcb7027823e175f30b16d24df060e9eef8b98870a8506dbace7b8dde5f99"
    sha256 cellar: :any,                 arm64_sonoma:  "ab700907735fa706f7ffbc12d16d9cec67d2185ae334cb87c1b330b98cb153a6"
    sha256 cellar: :any,                 arm64_ventura: "2c00a6f8493bd0e4b18ad11aba956f0d723e9e9e9fa03652be881f2d13219f36"
    sha256 cellar: :any,                 sonoma:        "1afab92fb95a54e74abebbf6520c5eb6683604a8e4bd767221040d20f05b2eb5"
    sha256 cellar: :any,                 ventura:       "eb27c03ae2c5a0ed31323ff6c8af7ed738cfff807dc5457049ecd1e90dc93ec2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1efac292aa726699149c4345caa3ed77168a9b580d1f5daa4b6351e58de3b8d"
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

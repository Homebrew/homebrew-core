class Sbcl < Formula
  desc "Steel Bank Common Lisp system"
  homepage "http://www.sbcl.org/"
  url "https://downloads.sourceforge.net/project/sbcl/sbcl/2.1.7/sbcl-2.1.7-source.tar.bz2"
  sha256 "12606f153832ae2003d2162a6b3a851a5e8969ccbbf7538d2b0fb32d17ea1dc6"
  license all_of: [:public_domain, "MIT", "Xerox", "BSD-3-Clause"]
  head "https://git.code.sf.net/p/sbcl/sbcl.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ecc7dc9f2176e56b1b2d9e10a117239fe6ecb6b8eb183059cb8485a3600a0d3c"
    sha256 cellar: :any_skip_relocation, big_sur:       "5974c3190e0d93475a1e22277cb74f6e1e77f678d1cda089e15483a1b60d02cc"
    sha256 cellar: :any_skip_relocation, catalina:      "fdbbe7d4b5179c7b9f69ca0cc446d61e782daae8d014c8f964532d9a90f65acc"
    sha256 cellar: :any_skip_relocation, mojave:        "3eddc8bf54c6779daf399b77b740ab22960e62abaf93757d21c37d6415f70ca6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a9788fc6421f5b5a75bc09b9218cb66c6ee14307d1aa24d1fe5d6ea149f6816"
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

class Sbcl < Formula
  desc "Steel Bank Common Lisp system"
  homepage "http://www.sbcl.org/"
  url "https://downloads.sourceforge.net/project/sbcl/sbcl/2.1.7/sbcl-2.1.7-source.tar.bz2"
  sha256 "12606f153832ae2003d2162a6b3a851a5e8969ccbbf7538d2b0fb32d17ea1dc6"
  license all_of: [:public_domain, "MIT", "Xerox", "BSD-3-Clause"]
  head "https://git.code.sf.net/p/sbcl/sbcl.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e7f428277f038d90fb853302e093f7b426eaa1695d26caedb8e4fdf88e54ba28"
    sha256 cellar: :any_skip_relocation, big_sur:       "20222fb83903bb6c1316d05690ac9b9d8e4e35e803fccaa280fb45882f71c2d4"
    sha256 cellar: :any_skip_relocation, catalina:      "aeab59a380a6ec9c3ee8ca4b3c28edd9ad1ea27700001299a68d43aa01b818bc"
    sha256 cellar: :any_skip_relocation, mojave:        "a138d329408cfa2a2a36648e1eae1af7aeaee7269e4609e830af0a9a9447c8aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59aaa5fcc459664872d1faeb93030689ec457924bc7d449111bfd364b50c4801"
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

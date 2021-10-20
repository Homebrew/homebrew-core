class Sbcl < Formula
  desc "Steel Bank Common Lisp system"
  homepage "http://www.sbcl.org/"
  url "https://downloads.sourceforge.net/project/sbcl/sbcl/2.1.9/sbcl-2.1.9-source.tar.bz2"
  sha256 "9e746ff12c4f78d2deabd95e48169b552f9472808cf8b8fc801d84df3e962fa1"
  license all_of: [:public_domain, "MIT", "Xerox", "BSD-3-Clause"]
  head "https://git.code.sf.net/p/sbcl/sbcl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a1f40fa7fff59aef4b65264a566050b4d241571e715a3c02a3a04fdb98d4fb09"
    sha256 cellar: :any_skip_relocation, big_sur:       "f8c9ec0cd0498ff23069576bae6d5c959a07d30341f0fd7289a70226936cb6fb"
    sha256 cellar: :any_skip_relocation, catalina:      "b3bb2b67fb0850705d1fec5ae20630087e189fcf1c7c2ac5bc6adce71dbefa16"
    sha256 cellar: :any_skip_relocation, mojave:        "9ea1618b1a189c93353622f61fbd7f3b115b389d69ba2d95fe466defb741ba6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea3c8073e192ffac051bd5a9c5ac8c9990c3790d030d59744a280cab3dea4bc8"
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

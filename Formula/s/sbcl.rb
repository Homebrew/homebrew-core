class Sbcl < Formula
  desc "Steel Bank Common Lisp system"
  homepage "https://www.sbcl.org/"
  url "https://downloads.sourceforge.net/project/sbcl/sbcl/2.5.6/sbcl-2.5.6-source.tar.bz2"
  sha256 "6dd7cebff6d38f2e41baece14c4c56a32e968828aaa4171b8e840852c5b43f35"
  license all_of: [:public_domain, "MIT", "Xerox", "BSD-3-Clause"]
  head "https://git.code.sf.net/p/sbcl/sbcl.git", branch: "master"

  livecheck do
    url "https://sourceforge.net/projects/sbcl/rss?path=/sbcl"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a13e85418e04ec670fd05b65ee0aeeb00872f0668a9b8a50aa6cd2a80562828e"
    sha256 cellar: :any,                 arm64_sonoma:  "46eb31c5c8396de1ae2856206686ccf8433da507d5401d4672ffc156f2a7431d"
    sha256 cellar: :any,                 arm64_ventura: "7a5412d2526fdab0a5a782859923a6c39a6d913012ae60ebbcea6b45d1b00e39"
    sha256 cellar: :any,                 sonoma:        "1e692457b68edb6c4eb51676278735793c1235f4199e43e3944d32ba105e0bba"
    sha256 cellar: :any,                 ventura:       "6d6c8f481636dfd831ba85898ec52d71632a7e53f0b2af389e6275053c6075b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "baa0db002ceb677a8c9cbefbc033310e9cb4c0f6bf9a1e8519debc343a67586c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f388a2c5ca9c3ce036c41332b20626c5264b2a300870e66b811e2e08068363d"
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

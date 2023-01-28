class Sbcl < Formula
  desc "Steel Bank Common Lisp system"
  homepage "http://www.sbcl.org/"
  url "https://downloads.sourceforge.net/project/sbcl/sbcl/2.3.1/sbcl-2.3.1-source.tar.bz2"
  sha256 "0ad5b600ea3389afe361672a54dc0d17dc519166da501b136b3013b237da049d"
  license all_of: [:public_domain, "MIT", "Xerox", "BSD-3-Clause"]
  head "https://git.code.sf.net/p/sbcl/sbcl.git", branch: "master"

  livecheck do
    url "https://sourceforge.net/projects/sbcl/rss?path=/sbcl"
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "442e21988adcf330c50b299d4ef40e6f1a442bb0c97615f650fb5d51d253ea7c"
    sha256 cellar: :any,                 arm64_monterey: "552a7ef288159477c30f239c044dbc9b5f16325087d084bbebb933242e796a57"
    sha256 cellar: :any,                 arm64_big_sur:  "32753f1e3f83045e61f64f69390f82b0cf056188acbbcd76ed6704943a5be0f8"
    sha256 cellar: :any,                 ventura:        "394fd112c230f95357c3c9d0c6a9ce396a5190e907206e412dc48c11fe1dd798"
    sha256 cellar: :any,                 monterey:       "cf0c69f58bf8fa8ce6810b4e072c5856cd9c075793e7af1c423e47c2351dd02a"
    sha256 cellar: :any,                 big_sur:        "dfd4623f95cec67e5dba17e6f275598cc8460745ce81507794e2a53a8cd66cc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7097f44ab2fedba8fadfc7cbac6e2bfc8f2ae5f19e59d106ba226e54feb389f4"
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
